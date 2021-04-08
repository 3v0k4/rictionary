URL = 'https://pl.bab.la/slownik/polski-angielski'

Found = Struct.new(
  :corrected,
  :translations,
  keyword_init: true
) do
  def found? = true
  def fallback_link = "#{URL}/#{corrected}"
end

NotFound = Class.new do
  def found? = false
  def corrected = nil
  def translations = []
  def fallback_link = nil
end

class FetchBablaTranslations
  def initialize(http_client: HttpClient.new, parse_babla_html: ParseBablaHtml.new)
    @http_client = http_client
    @parse_babla_html = parse_babla_html
  end

  def call(query)
    corrected = CorrectQueryViaBabla.new.call(query)
    return NotFound.new if corrected.nil?
    link = "#{URL}/#{corrected.gsub(' ', '-')}"
    html = @http_client.get_or(link, "")
    translations = @parse_babla_html.call(html, corrected)
    Found.new(corrected: corrected, translations: translations)
  end
end
