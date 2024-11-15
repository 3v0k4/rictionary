class FetchWiktionaryPage
  def initialize(http_client: HttpClient.new)
    @http_client = http_client
  end

  def call(query)
    q = query.gsub(" ", "_")
    fetch(q)
  end

  private

  def fetch(query)
    uri_builder = ->(query) { "https://pl.wiktionary.org/api/rest_v1/page/html/#{query}" }
    response = @http_client.get_or_redirect(uri_builder, query, "")
    polish_or_other_langs_or_nil(response)
  end

  def polish_or_other_langs_or_nil(html)
    if html.force_encoding(Encoding::UTF_8).downcase.include?("język")
      html
    else
      nil
    end
  end
end
