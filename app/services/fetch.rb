class Fetch
  def call(query)
    if query.empty?
      return ViewModel.new(query: query, corrected_query: query, parse_result: ParseHtml.new.call(""))
    end

    corrected, html = corrected(query)

    if corrected.nil? && html.nil?
      return ViewModel.new(query: query, corrected_query: query, parse_result: ParseHtml.new.call(""))
    end

    ViewModel.new(query: query, corrected_query: corrected, parse_result: ParseHtml.new.call(html))
  end

  private

  def corrected(query)
    [query, query.downcase, correct(query)].each do |q|
      break if q.nil?
      break [q, html(q)] unless html(q).downcase.include?("not found")
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
