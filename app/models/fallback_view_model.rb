FallbackViewModel = Struct.new(
  :query,
  :corrected_query,
  :translations,
  keyword_init: true
) do
  def link
    "https://pl.bab.la/slownik/polski-angielski/#{corrected_query}"
  end
end
