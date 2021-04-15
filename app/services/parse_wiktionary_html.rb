class ParseWiktionaryHtml
  REFERENCE_1 = /\s*\(\d\.\d\)\s*/

  def call(html)
    doc = Nokogiri::HTML(html)
    polish = doc.xpath('//*[text() = "język polski"]/../../..')

    ParseResult.new(
      categories: categories(polish),
      examples: examples(polish),
      images: images(polish),
      declination: declination(polish),
      conjugation: conjugation(polish),
      translations: translations(polish),
      other_translations: other_translations(doc)
    )
  end

  private

  def categories(doc)
    doc
      .xpath('.//*[contains(text(), "znaczenia")]/../..')
      .xpath('./following-sibling::*//*[contains(text(), "dokonany")]/..')
      .map { |category| category.xpath('.//*[not(self::style)]/text()') }
      .map { |category_fragments| category_fragments.map(&:text) }
      .map { |category_fragments| category_fragments.join(' ') }
      .map(&method(:clean))
      .uniq
  end

  def examples(doc)
    doc
      .xpath('.//*[contains(text(), "przykłady")]/../..')
      .xpath('.//i')
      .map(&:text)
      .map(&method(:clean))
      .uniq
  end

  def images(doc)
    doc
      .xpath('.//figure')
      .map do |figure|
        url = figure.xpath('.//img/@src').text.yield_self(&method(:clean))
        caption = figure.xpath('.//figcaption').text.yield_self(&method(:clean))
        { url: url, caption: caption }
      end
      .uniq
  end

  def declination(base)
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
      .xpath('(//a[text() = "' + case_ + '"])[1]/../../td[' + number.to_s + ']//text()')
      .reject { |x| x.class == Nokogiri::XML::CDATA }
      .map(&:text)
      .join(" ")
      .yield_self(&method(:clean))
  end

  def conjugation(doc)
    base = doc
      .xpath('.//table[contains(@class, "odmiana")]')
      .first

    return nil unless base
    return nil if conjugation_(base, "bezokolicznik").empty?

    {
      infinitive: conjugation_(base, "bezokolicznik").first,
      present: conjugation_(base, "czas teraźniejszy"),
      future: conjugation_(base, "czas przyszły prosty"),
      past: {
        masculine: conjugation_(base, "czas przeszły"),
        feminine: conjugation_(base, "czas przeszły", "/following-sibling::tr[1]"),
        neuter:
          ['', ''] +
          conjugation_(base, "czas przeszły", "/following-sibling::tr[2]").drop(2).take(1) +
          conjugation_(base, "czas przeszły", "/following-sibling::tr[1]").drop(3),
      },
      imperative: conjugation_(base, "tryb rozkazujący"),
    }
  end

  def conjugation_(base, tense, move = '')
    base
      .xpath('.//*[text() = "' + tense + '"]/../..' + move + '/td')
      .map(&:text)
      .map(&method(:clean))
  end

  def translations(doc)
    doc
      .xpath('.//*[starts-with(normalize-space(text()), "angielski:")]//text()')
      .reject { |x| x.class == Nokogiri::XML::CDATA }
      .map(&:text)
      .join
      .yield_self { |string| string.sub('angielski:', '') }
      .yield_self { |string| string.gsub(';', '') }
      .split(REFERENCE_1)
      .uniq
      .reject(&:empty?)
  end

  def other_translations(doc)
    doc
      .xpath('.//*[starts-with(text(), "język ") and not(contains(text(), "język polski"))]')
      .reduce({}) do |acc, language|
        xs = language
          .xpath('./../../..')
          .xpath('.//*[contains(text(), "znaczenia")]/../..')
          .xpath('./following-sibling::*')
          .take_while { |x| x.node_name != 'span' }
          .flat_map { |x| x.xpath('.//dd') }
          .map do |xs|
            xs
              .xpath('.//text()')
              .reject { |x| x.class == Nokogiri::XML::CDATA }
              .map(&:text)
              .reject(&method(:reference?))
              .map(&method(:collapse_spaces))
              .reject(&:empty?)
              .join('')
              .strip
          end
          .reject(&:empty?)
        acc.merge(language.text => xs)
      end
  end

  def reference?(string) = reference_1?(string) || reference_2?(string)

  def reference_1?(string) = REFERENCE_1.match?(string)

  def reference_2?(string) = /\s*\[\d\]\s*/.match?(string)

  def collapse_spaces(string) = string.gsub(/\s+/, " ")

  def clean(string) = string
    .gsub(REFERENCE_1, " ")
    .gsub(/\s*\[\d\]\s*/, " ")
    .yield_self(&method(:collapse_spaces))
    .strip
    .chomp
end
