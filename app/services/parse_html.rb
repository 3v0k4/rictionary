Result = Struct.new(:translations, :examples, keyword_init: true)

class ParseHtml
  def call(html)
    doc = Nokogiri::HTML(html)
    Result.new(
      translations: translations(doc),
      examples: examples(doc)
    )
  end

  private

  def translations(doc)
    doc
      .xpath('//*[contains(text(), "angielski")]')
      .css("a")
      .map(&:text)
      .uniq
  end

  def examples(doc)
    doc
      .xpath('//*[contains(text(), "przykłady")]/../..')
      .css("i")
      .map(&:text)
      .uniq
  end
end
