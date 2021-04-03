class Fetch
  def call(query)
    return NoQueryViewModel.new if query.empty?

    q, h = try(query)
    return view_model(query, q, h) unless h.nil?

    q, h = try(query.downcase)
    return view_model(query, q, h) unless h.nil?

    q, h = try(correct_via_wiktionary(query.downcase))
    return view_model(query, q, h) unless h.nil?

    q, h = [correct_via_babla(q), nil]

    if q.nil?
      NotFoundViewModel.new(query: query, corrected_query: query)
    else
      fallback_(query, q)
    end
  end

  private

  def fallback_(query, corrected)
    link = "https://pl.bab.la/slownik/polski-angielski/#{corrected}".gsub(' ', '-')
    ts = parse_html_from_babla(get_or(link, ""), corrected)
    FallbackViewModel.new(query: query, corrected_query: corrected, translations: ts)
  end

  def view_model(query, corrected, html)
    parsed = ParseHtml.new.call(html)
    if parsed.translations.any?
      ViewModel.new(query: query, corrected_query: corrected, parse_result: parsed, fallback_link: nil)
    else
      corrected_via_babla = correct_via_babla(corrected)
      if corrected_via_babla
        flink = "https://pl.bab.la/slownik/polski-angielski/#{corrected}"
        ts = fallback_("", corrected_via_babla).translations
        ViewModel.new(query: query, corrected_query: corrected, parse_result: parsed.with_translations(ts), fallback_link: flink)
      else
        ts = []
        ViewModel.new(query: query, corrected_query: corrected, parse_result: parsed.with_translations(ts), fallback_link: flink)
      end
    end
  end

  def parse_html_from_babla(html, corrected)
    doc = Nokogiri::HTML(html)
    doc
      .xpath('//*[contains(@class, "babQuickResult") and text() = "' + corrected + '"]')
      .map { |x| x.xpath('../../*[contains(@class, "quick-result-overview")]//a/text()') }
      .flatten
      .map(&:text)
  end

  def try(query)
    q = query.gsub(" ", "_")
    [query, polish_or_other_langs_or_nil(html(q))]
  end

  def polish_or_other_langs_or_nil(h)
    if h.force_encoding(Encoding::UTF_8).downcase.include?("język polski")
      h
    elsif h.force_encoding(Encoding::UTF_8).downcase.include?("język")
      h
    else
      nil
    end
  end

  def html(query)
    uri_builder = ->(query) { "https://pl.wiktionary.org/api/rest_v1/page/html/#{query}" }
    get_or_redirect(uri_builder, query, "")
  end

  def get_or(address, default)
    get_or_redirect(->(_) { address }, nil, default)
  end

  def get_or_redirect(uri_builder, query, default)
    uri = URI(URI::Parser.new.escape(uri_builder.call(query)))
    response = Net::HTTP.get_response(uri)
    if response.code == "302"
      new_query = URI::Parser.new.unescape(response["location"])
      return get_or_redirect(uri_builder, new_query, default)
    end
    response.body
  rescue StandardError
    default
  end

  def correct_via_wiktionary(query)
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
    JSON.parse(get_or("https://#{host}/#{path}?#{q}", [nil, [query]].to_json))
      .second
      .filter { |suggestion| suggestion.size == query.size }
      .first || query
  end

  def correct_via_babla(query)
    post(query.gsub(" ", "+"))
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
