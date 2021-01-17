class Fetch
  def call(query)
    ViewModel.new(
      query: query,
      parse_result: ParseHtml.new.call(html(query))
    )
  end

  private

  def html(query)
    if query.empty?
      ""
    else
      host = "pl.wiktionary.org"
      path = "api/rest_v1/page/html/#{query}"
      uri = URI::Parser.new.escape("https://#{host}/#{path}")
      Net::HTTP.get(URI(uri))
    end
  end
end
