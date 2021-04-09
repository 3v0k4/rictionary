WiktionaryViewModel = Struct.new(
  :query,
  :parse_result,
  :fallback_link,
  keyword_init: true
) do
  def link
    "https://pl.wiktionary.org/wiki/#{query}"
  end
end
