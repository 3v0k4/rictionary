class ParseWiktionaryHtml
  def call(html)
    doc = Nokogiri::HTML(html)
    ParseResult.new(
      categories: categories(doc),
      translations: translations(doc),
      examples: examples(doc),
      images: images(doc),
      declination: declination(doc),
      conjugation: conjugation(doc),
      other_translations: other_translations(doc)
    )
  end

  private

  def categories(doc)
    doc
      .xpath('//*[text() = "język polski"]/../../..//*[contains(text(), "znaczenia")]/../../following-sibling::*')
      .take_while { |x| x.node_name != "span" }
      .flat_map { |x| x.xpath('//i[contains(text(), "dokonany")]/..') }
      .map do |d|
        d
          .xpath('*[not(self::style)]')
          .map(&:text)
          .map(&:strip)
          .reject(&:empty?)
          .join(' ')
      end
      .uniq
  end

  def translations(doc)
    doc
      .xpath('//*[starts-with(normalize-space(text()), "angielski:")]//text()')
      .reject { |x| x.class == Nokogiri::XML::CDATA }
      .join
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
      .xpath('//*[text() = "język polski"]/../../..//figure')
      .map do |figure|
        url = figure.xpath('.//img/@src').text
        caption = figure
          .xpath('.//figcaption')
          .text
          .split(' ')
          .reject { |string| /\(\d+.\d+\)/.match?(string) }
          .join(' ')
        { url: url, caption: caption }
      end
      .uniq
  end

  def declination(doc)
    base = doc.xpath('//*[text() = "język polski"]/../../..')
    return nil if declination_(base, "mianownik", 2).empty?

    {
      nominative_singular: declination_(base, "mianownik", 2),
      nominative_plural: declination_(base, "mianownik", 3),
      genitive_singular: declination_(base, "dopełniacz", 2),
      genitive_plural: declination_(base, "dopełniacz", 3),
      dative_singular: declination_(base, "celownik", 2),
      dative_plural: declination_(base, "celownik", 3),
      accusative_singular: declination_(base, "biernik", 2),
      accusative_plural: declination_(base, "biernik", 3),
      instrumental_singular: declination_(base, "narzędnik", 2),
      instrumental_plural: declination_(base, "narzędnik", 3),
      locative_singular: declination_(base, "miejscownik", 2),
      locative_plural: declination_(base, "miejscownik", 3),
      vocative_singular: declination_(base, "wołacz", 2),
      vocative_plural: declination_(base, "wołacz", 3),
    }
  end

  def declination_(base, case_, number)
    base
      .xpath('(//a[text() = "' + case_ + '"])[1]/../../td[' + number.to_s + ']')
      .children
      .filter("//text()|//*[not(self::style) and not(self::sup)]")
      .map(&:text)
      .map(&:strip)
      .map(&:chomp)
      .reject(&:empty?)
      .join(" ")
  end

  def conjugation(doc)
    base = doc.xpath('(//*[text() = "język polski"]/../../..//table[contains(@class, "odmiana")])[1]')
    return nil if base.xpath('.//*[text() = "bezokolicznik"]/../../td').empty?

    {
      infinitive: base.xpath('.//*[text() = "bezokolicznik"]/../../td').text.strip.gsub(/\s+/, " "),
      present: base.xpath('.//*[text() = "czas teraźniejszy"]/../../td').map(&:text).map(&:strip).map { |x| x.gsub(/\s+/, " ") },
      future: base.xpath('.//*[text() = "czas przyszły prosty"]/../../td').map(&:text).map(&:strip).map { |x| x.gsub(/\s+/, " ") },
      past: {
        masculine: base.xpath('.//*[text() = "czas przeszły"]/../../td').map(&:text).map(&:strip).map { |x| x.gsub(/\s+/, " ") },
        feminine: base.xpath('.//*[text() = "czas przeszły"]/../../following-sibling::tr[1]/td').map(&:text).map(&:strip).map { |x| x.gsub(/\s+/, " ") },
        neuter:
          ['', ''] +
          base.xpath('.//*[text() = "czas przeszły"]/../../following-sibling::tr[2]/td[3]').map(&:text).map(&:strip).map { |x| x.gsub(/\s+/, " ") } +
          base.xpath('.//*[text() = "czas przeszły"]/../../following-sibling::tr[1]/td[position() >= 4]').map(&:text).map(&:strip).map { |x| x.gsub(/\s+/, " ") },
      },
      imperative: base.xpath('.//*[text() = "tryb rozkazujący"]/../../td').map(&:text).map(&:strip).map { |x| x.gsub(/\s+/, " ") },
    }
  end

  def other_translations(doc)
    doc
      .xpath('//*[starts-with(text(), "język ")]')
      .reject { |x| x.text == "język polski" }
      .reduce({}) do |acc, language|
        xs = language
          .xpath('./../../..//*[contains(text(), "znaczenia")]/../../following-sibling::*')
          .take_while { |x| x.node_name != 'span' }
          .flat_map do |x|
            x.xpath('.//dd')
          end
          .map do |xs|
            xs
              .xpath('.//text()')
              .reject { |x| x.class == Nokogiri::XML::CDATA }
              .map(&:text)
              .reject { |str| /\s*\(\d\.\d\)\s*/.match?(str) }
              .reject { |str| /\s*\[\d\]\s*/.match?(str) }
              .map { |str| str.gsub(/\s+/, " ") }
              .map(&:chomp)
              .reject(&:empty?)
              .join('')
              .strip
          end
          .reject(&:empty?)
        acc.merge(language.text => xs)
      end
  end
end