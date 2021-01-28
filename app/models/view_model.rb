ViewModel = Struct.new(
  :query,
  :corrected_query,
  :parse_result,
  :fallback_link,
  keyword_init: true
) do
  def link
    "https://pl.wiktionary.org/wiki/#{corrected_query}"
  end
end
