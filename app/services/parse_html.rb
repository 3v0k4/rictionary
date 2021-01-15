Result = Struct.new(:translations, :examples, :images, keyword_init: true)

class ParseHtml
  def call(html)
    doc = Nokogiri::HTML(html)
    Result.new(
      translations: translations(doc),
      examples: examples(doc),
      images: images(doc)
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

  def images(doc)
    doc
      .xpath('//figure//img/@src')
      .map(&:text)
      .uniq
  end
end
