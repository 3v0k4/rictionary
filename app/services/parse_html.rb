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
      .text
      .split(' ')
      .map(&:strip)
      .join(' ')
      .split(/\s\(\d+.\d+\)\s/)
      .drop(1)
      .map { |string| string.sub(';', '') }
      .uniq
  end

  def examples(doc)
    doc
      .xpath('//*[text() = "język polski"]/../../..//*[contains(text(), "przykłady")]/../..')
      .css("i")
      .map(&:text)
      .map { |string| string.split(' ').map(&:strip).join(' ') }
      .uniq
  end

  def images(doc)
    doc
      .xpath('//figure//img/@src')
      .map(&:text)
      .uniq
  end

  def declination(doc)
    base = doc.xpath('//*[text() = "język polski"]/../../..')
    return nil if base.xpath('(//a[text() = "mianownik"])[1]/../../td[2]').empty?

    {
      nominative_singular: base.xpath('(//a[text() = "mianownik"])[1]/../../td[2]').text,
      nominative_plural: base.xpath('(//a[text() = "mianownik"])[1]/../../td[3]').text,
      genitive_singular: base.xpath('(//a[text() = "dopełniacz"])[1]/../../td[2]').text,
      genitive_plural: base.xpath('(//a[text() = "dopełniacz"])[1]/../../td[3]').text,
      dative_singular: base.xpath('(//a[text() = "celownik"])[1]/../../td[2]').text,
      dative_plural: base.xpath('(//a[text() = "celownik"])[1]/../../td[3]').text,
      accusative_singular: base.xpath('(//a[text() = "biernik"])[1]/../../td[2]').text,
      accusative_plural: base.xpath('(//a[text() = "biernik"])[1]/../../td[3]').text,
      instrumental_singular: base.xpath('(//a[text() = "narzędnik"])[1]/../../td[2]').text,
      instrumental_plural: base.xpath('(//a[text() = "narzędnik"])[1]/../../td[3]').text,
      locative_singular: base.xpath('(//a[text() = "miejscownik"])[1]/../../td[2]').text,
      locative_plural: base.xpath('(//a[text() = "miejscownik"])[1]/../../td[3]').text,
      vocative_singular: base.xpath('(//a[text() = "wołacz"])[1]/../../td[2]').text,
      vocative_plural: base.xpath('(//a[text() = "wołacz"])[1]/../../td[3]').text,
    }
  end

  def conjugation(doc)
    base = doc.xpath('(//*[text() = "język polski"]/../../..//table[contains(@class, "odmiana")])[1]')
    return nil if base.xpath('.//*[text() = "bezokolicznik"]/../../td').empty?

    {
      infinitive: base.xpath('.//*[text() = "bezokolicznik"]/../../td').text.strip,
      present: base.xpath('.//*[text() = "czas teraźniejszy"]/../../td').map(&:text),
      past: {
        masculine: base.xpath('.//*[text() = "czas przeszły"]/../../td').map(&:text),
        feminine: base.xpath('.//*[text() = "czas przeszły"]/../../following-sibling::tr[1]/td').map(&:text),
        neuter:
          ['', ''] +
          base.xpath('.//*[text() = "czas przeszły"]/../../following-sibling::tr[2]/td[3]').map(&:text) +
          base.xpath('.//*[text() = "czas przeszły"]/../../following-sibling::tr[1]/td[position() >= 4]').map(&:text),
      },
      imperative: base.xpath('.//*[text() = "tryb rozkazujący"]/../../td').map(&:text),
    }
  end
end
