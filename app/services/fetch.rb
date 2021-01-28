class Fetch
  def call(query)
    return NoQueryViewModel.new if query.empty?
    corrected, html = corrected(query)
    return NotFoundViewModel.new(query: query, corrected_query: query) if (corrected.nil? && html.nil?)
    return FallbackViewModel.new(query: query, corrected_query: corrected) if (!corrected.nil? && html.nil?)
    view_model(query, corrected, html)
  end

  private

  def view_model(query, corrected, html)
    parsed = ParseHtml.new.call(html)
    fallback = parsed.translations.any? ?
      nil :
      "https://pl.bab.la/slownik/polski-angielski/#{fallback(corrected)}"
    ViewModel.new(query: query, corrected_query: corrected, parse_result: parsed, fallback_link: fallback)
  end

  def corrected(query)
    q, h = try(query)
    return [q, h] unless h.nil?

    q, h = try(query.downcase)
    return [q, h] unless h.nil?

    q, h = try(correct(query.downcase))
    return [q, h] unless h.nil?

    [fallback(q), nil]
  end

  def try(query)
    q = query.gsub(" ", "_")
    [query, polish_or_nil(html(q))]
  end

  def polish_or_nil(h)
    if h.force_encoding(Encoding::UTF_8).downcase.include?("język polski")
      h
    else
      nil
    end
  end

  def html(query)
    host = "pl.wiktionary.org"
    path = "api/rest_v1/page/html/#{query}"
    get_or("https://#{host}/#{path}", "")
  end

  def get_or(address, default)
    uri = URI::Parser.new.escape(address)
    Net::HTTP.get(URI(uri))
  rescue StandardError
    default
  end

  def correct(query)
    host = "pl.wiktionary.org"
    path = "w/api.php"
    q = [
      "action=opensearch",
      "format=json",
      "formatversion=2",
      "search=#{query}",
      "namespace=0%7C100%7C102",
      "limit=10"
    ].join('&')
    JSON.parse(get_or("https://#{host}/#{path}?#{q}", [nil, [query]]))
      .second
      .filter { |suggestion| suggestion.size == query.size }
      .first || query
  end

  def fallback(query)
    post(query)
      .map { |suggestion| suggestion.fetch("value") }
      .find { |suggestion| suggestion.size == query.size }
  end

  def post(query)
    uri = URI.parse("https://bab.la/ax/dictionary/ta")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded; charset=UTF-8"
    request.set_form_data(d: "enpl", q: query)
    req_options = { use_ssl: uri.scheme == "https" }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    JSON.parse(response.body)
  rescue StandardError
    []
  end
end
