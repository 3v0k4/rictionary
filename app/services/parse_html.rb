class ParseHtml
  def call(html)
    doc = Nokogiri::HTML(html)
    ParseResult.new(
      translations: translations(doc),
      examples: examples(doc),
      images: images(doc),
      declination: declination(doc),
      conjugation: conjugation(doc)
    )
  end

  private

  def translations(doc)
    doc
      .xpath('//*[contains(text(), "angielski:")]')
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

  def declination(doc)
    return nil if doc.xpath('//a[text() = "mianownik"]/../../td[2]').empty?

    {
      nominative_singular: doc.xpath('//a[text() = "mianownik"]/../../td[2]').text,
      nominative_plural: doc.xpath('//a[text() = "mianownik"]/../../td[3]').text,
      genitive_singular: doc.xpath('//a[text() = "dopełniacz"]/../../td[2]').text,
      genitive_plural: doc.xpath('//a[text() = "dopełniacz"]/../../td[3]').text,
      dative_singular: doc.xpath('//a[text() = "celownik"]/../../td[2]').text,
      dative_plural: doc.xpath('//a[text() = "celownik"]/../../td[3]').text,
      accusative_singular: doc.xpath('//a[text() = "biernik"]/../../td[2]').text,
      accusative_plural: doc.xpath('//a[text() = "biernik"]/../../td[3]').text,
      instrumental_singular: doc.xpath('//a[text() = "narzędnik"]/../../td[2]').text,
      instrumental_plural: doc.xpath('//a[text() = "narzędnik"]/../../td[3]').text,
      locative_singular: doc.xpath('//a[text() = "miejscownik"]/../../td[2]').text,
      locative_plural: doc.xpath('//a[text() = "miejscownik"]/../../td[3]').text,
      vocative_singular: doc.xpath('//a[text() = "wołacz"]/../../td[2]').text,
      vocative_plural: doc.xpath('//a[text() = "wołacz"]/../../td[3]').text,
    }
  end

  def conjugation(doc)
    return nil if doc.xpath('(//table[contains(@class, "odmiana")])[1]//*[text() = "bezokolicznik"]/../../td').empty?

    {
      infinitive: doc.xpath('(//table[contains(@class, "odmiana")])[1]//*[text() = "bezokolicznik"]/../../td').text.strip,
      present: doc.xpath('(//table[contains(@class, "odmiana")])[1]//*[text() = "czas teraźniejszy"]/../../td').map(&:text),
      past: {
        masculine: doc.xpath('(//table[contains(@class, "odmiana")])[1]//*[text() = "czas przeszły"]/../../td').map(&:text),
        feminine: doc.xpath('(//table[contains(@class, "odmiana")])[1]//*[text() = "czas przeszły"]/../../following-sibling::tr[1]/td').map(&:text),
        neutral:
          ['', ''] +
          doc.xpath('(//table[contains(@class, "odmiana")])[1]//*[text() = "czas przeszły"]/../../following-sibling::tr[2]/td[3]').map(&:text) +
          doc.xpath('(//table[contains(@class, "odmiana")])[1]//*[text() = "czas przeszły"]/../../following-sibling::tr[1]/td[position() >= 4]').map(&:text),
      },
      imperative: doc.xpath('(//table[contains(@class, "odmiana")])[1]//*[text() = "tryb rozkazujący"]/../../td').map(&:text),
    }
  end
end
