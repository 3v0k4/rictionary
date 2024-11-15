class FetchBablaTranslations
  URL = "https://pl.bab.la/slownik/polski-angielski"

  def initialize(
    http_client: HttpClient.new,
    parse_babla_html: ParseBablaHtml.new,
    correct_query_via_babla: CorrectQueryViaBabla.new
  )
    @http_client = http_client
    @parse_babla_html = parse_babla_html
    @correct_query_via_babla = correct_query_via_babla
  end

  def call(query)
    corrected, translations = fetch(query)

    if translations.any?
      Found.new(corrected: corrected, translations: translations)
    else
      NotFound.new
    end
  end

  private

  def fetch(query)
    corrected = @correct_query_via_babla.call(query) || query
    url = "#{URL}/#{corrected.gsub(' ', '-')}"
    html = @http_client.get_or(url, "")
    [ corrected, @parse_babla_html.call(html, corrected) ]
  end
end
