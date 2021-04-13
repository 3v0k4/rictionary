WiktionaryViewModel = Struct.new(
  :query,
  :parse_result,
  :babla_url,
  keyword_init: true
) do
  def initialize(query:, parse_result:, babla_url: nil)
    super
  end

  def wiktionary_link
    "https://pl.wiktionary.org/wiki/#{query}"
  end

  def with_babla_translations(response)
    WiktionaryViewModel.new(
      query: self.query,
      parse_result: self.parse_result.with_translations(response.translations),
      babla_url: response.babla_url
    )
  end
end
