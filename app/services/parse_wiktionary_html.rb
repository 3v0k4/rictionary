class ParseWiktionaryHtml
  REFERENCE = /\s*\(\d\.\d\)\s*/

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
      .xpath('.//*[contains(text(), "przykłady")]/..')
      .xpath('./following-sibling::dt[1]/preceding-sibling::dd[preceding-sibling::dt/*[contains(text(), "przykłady")]]')
      .map(&:text)
      .map(&method(:clean))
      .uniq
      .reject(&:empty?) +
    doc
      .xpath('.//dl[name(./*[1]) = "dt"]/dt/*[contains(text(), "przykłady")]/../parent::dl//i')
      .map(&:text)
      .map(&method(:clean))
      .uniq
      .reject(&:empty?)
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

    if declination_(base, "mianownik", 4).empty?
      {
        singular: {
          nominative: declination_(base, "mianownik", 2),
          genitive: declination_(base, "dopełniacz", 2),
          dative: declination_(base, "celownik", 2),
          accusative: declination_(base, "biernik", 2),
          instrumental: declination_(base, "narzędnik", 2),
          locative: declination_(base, "miejscownik", 2),
          vocative: declination_(base, "wołacz", 2),
        },
        plural: {
          nominative: declination_(base, "mianownik", 3),
          genitive: declination_(base, "dopełniacz", 3),
          dative: declination_(base, "celownik", 3),
          accusative: declination_(base, "biernik", 3),
          instrumental: declination_(base, "narzędnik", 3),
          locative: declination_(base, "miejscownik", 3),
          vocative: declination_(base, "wołacz", 3),
        },
      }
    else
      {
        singular: {
          masculine_personal: {
            nominative: declination_(base, "mianownik", 2),
            genitive: declination_(base, "dopełniacz", 2),
            dative: declination_(base, "celownik", 2),
            accusative: declination_(base, "biernik", 2),
            instrumental: declination_(base, "narzędnik", 2),
            locative: declination_(base, "miejscownik", 2),
            vocative: declination_(base, "wołacz", 2),
          },
          masculine_inanimate: {
            nominative: declination_(base, "mianownik", 2),
            genitive: declination_(base, "dopełniacz", 2),
            dative: declination_(base, "celownik", 2),
            accusative: declination_(base, "biernik", 3),
            instrumental: declination_(base, "narzędnik", 2),
            locative: declination_(base, "miejscownik", 2),
            vocative: declination_(base, "wołacz", 2),
          },
          feminine: {
            nominative: declination_(base, "mianownik", 3),
            genitive: declination_(base, "dopełniacz", 3),
            dative: declination_(base, "celownik", 3),
            accusative: declination_(base, "biernik", 4),
            instrumental: declination_(base, "narzędnik", 3),
            locative: declination_(base, "miejscownik", 3),
            vocative: declination_(base, "wołacz", 3),
          },
          neuter: {
            nominative: declination_(base, "mianownik", 4),
            genitive: declination_(base, "dopełniacz", 4),
            dative: declination_(base, "celownik", 4),
            accusative: declination_(base, "biernik", 5),
            instrumental: declination_(base, "narzędnik", 4),
            locative: declination_(base, "miejscownik", 4),
            vocative: declination_(base, "wołacz", 4),
          },
        },
        plural: {
          masculine_personal: {
            nominative: declination_(base, "mianownik", 5),
            genitive: declination_(base, "dopełniacz", 5),
            dative: declination_(base, "celownik", 5),
            accusative: declination_(base, "biernik", 6),
            instrumental: declination_(base, "narzędnik", 5),
            locative: declination_(base, "miejscownik", 5),
            vocative: declination_(base, "wołacz", 5),
          },
          non_masculine_personal: {
            nominative: declination_(base, "mianownik", 6),
            genitive: declination_(base, "dopełniacz", 5),
            dative: declination_(base, "celownik", 5),
            accusative: declination_(base, "biernik", 7),
            instrumental: declination_(base, "narzędnik", 5),
            locative: declination_(base, "miejscownik", 5),
            vocative: declination_(base, "wołacz", 6),
          },
        },
      }
    end
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
      .split(REFERENCE)
      .uniq
      .reject(&:empty?)
  end

  def other_translations(doc)
    doc
      .xpath('.//*[starts-with(text(), "język ") and not(contains(text(), "język polski"))]')
      .reduce({}) { |acc, language| acc.merge(language.text => language_(language)) }
  end

  def language_(language)
    language
      .xpath('./../../..')
      .xpath('.//*[contains(text(), "rzeczownik")]/..')
      .xpath('./following-sibling::p[1]/preceding-sibling::dl[preceding-sibling::p/*[contains(text(), "rzeczownik")]]')
      .xpath('./dd')
      .map { |x| x.children.reject{ _1.name == "style" }.map(&:text).join("") }
      .map(&method(:clean))
      .uniq
      .reject(&:empty?) +
    language
      .xpath('./../../..')
      .xpath('.//*[contains(text(), "rzeczownik")]/../following-sibling::dl[1]')
      .xpath('./dt[1]/preceding-sibling::dd')
      .map { |x| x.children.reject{ _1.name == "style" }.map(&:text).join("") }
      .map(&method(:clean))
      .uniq
      .reject(&:empty?) +
    language
      .xpath('./../../..')
      .xpath('.//*[contains(text(), "rzeczownik")]/../following-sibling::dl[1]')
      .xpath('./dd')
      .map { |x| x.children.reject{ _1.name == "style" }.map(&:text).join("") }
      .map(&method(:clean))
      .uniq
      .reject(&:empty?) +
    language
      .xpath('./../../..')
      .xpath('.//*[contains(text(), "przymiotnik")]/../following-sibling::dl[1]')
      .xpath('./dt[1]/preceding-sibling::dd')
      .map(&:text)
      .map(&method(:clean))
      .uniq
      .reject(&:empty?) +
    (language
      .xpath('./../../..')
      .xpath('.//*[contains(text(), "czasownik")]/../following-sibling::dl[1]')
      .xpath('./dt')
      .any? ?
    language
      .xpath('./../../..')
      .xpath('.//*[contains(text(), "czasownik")]/../following-sibling::dl[1]')
      .xpath('./dt[1]/preceding-sibling::dd')
      .map(&:text)
      .map(&method(:clean))
      .uniq
      .reject(&:empty?) :
    language
      .xpath('./../../..')
      .xpath('.//*[contains(text(), "czasownik")]/../following-sibling::dl[1]')
      .xpath('./dd')
      .map { |x| x.children.reject{ _1.name == "style" }.map(&:text).join("") }
      .map(&method(:clean))
      .uniq
      .reject(&:empty?))
  end

  def clean(string)
    string
      .gsub(REFERENCE, " ")
      .gsub(/\s*\[\d\]\s*/, " ")
      .gsub(/\s+/, " ")
      .strip
      .chomp
  end
end
