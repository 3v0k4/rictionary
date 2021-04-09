WiktionaryViewModel = Struct.new(
  :query,
  :parse_result,
  :babla_url,
  keyword_init: true
) do
  def wiktionary_link
    "https://pl.wiktionary.org/wiki/#{query}"
  end
end
