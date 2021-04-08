FallbackViewModel = Struct.new(
  :query,
  :translations,
  keyword_init: true
) do
  def link
    "https://pl.bab.la/slownik/polski-angielski/#{query}"
  end
end
