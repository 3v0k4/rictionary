class Fetch
  def call(query)
    corrected_query = correct_query(query) || query
    ViewModel.new(
      query: query,
      corrected_query: corrected_query,
      parse_result: ParseHtml.new.call(html(corrected_query))
    )
  end

  private

  def html(query)
    if query.empty?
      ""
    else
      host = "pl.wiktionary.org"
      path = "api/rest_v1/page/html/#{query}"
      get_or("https://#{host}/#{path}", "")
    end
  end

  def get_or(address, default)
    uri = URI::Parser.new.escape(address)
    Net::HTTP.get(URI(uri))
  rescue StandardError
    default
  end

  def correct_query(query)
    uri = URI.parse("https://bab.la/ax/dictionary/ta")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded; charset=UTF-8"
    request.set_form_data(d: "enpl", q: query)
    req_options = { use_ssl: uri.scheme == "https" }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    parsed = JSON.parse(response.body)
    parsed[0]&.fetch("value")
  rescue StandardError
    nil
  end
end
