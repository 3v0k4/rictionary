ParseResult = Struct.new(
  :categories,
  :translations,
  :examples,
  :images,
  :declination,
  :conjugation,
  :other_translations,
  keyword_init: true
) do
  def with_translations(translations)
    ParseResult.new(
      categories: self.categories,
      translations: translations,
      examples: self.examples,
      images: self.images,
      declination: self.declination,
      conjugation: self.conjugation,
      other_translations: self.other_translations
    )
  end
end

