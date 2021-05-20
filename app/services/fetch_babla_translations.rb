URL = 'https://pl.bab.la/slownik/polski-angielski'

Found = Struct.new(
  :corrected,
  :translations,
  keyword_init: true
) do
  def nil? = false
  def babla_url = "#{URL}/#{corrected}"
end

NotFound = Class.new do
  def nil? = true
  def corrected = nil
  def translations = []
  def babla_url = nil
end

class FetchBablaTranslations
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
    [corrected, @parse_babla_html.call(html, corrected)]
  end
end
