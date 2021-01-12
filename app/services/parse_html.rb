Result = Struct.new(:translations, keyword_init: true)

class ParseHtml
  def call(html)
    doc = Nokogiri::HTML(html)
    Result.new(translations: translations(doc))
  end

  private

  def translations(doc)
    doc
      .xpath('//*[contains(text(), "angielski")]')
      .css("a")
      .map(&:text)
      .uniq
  end
end
