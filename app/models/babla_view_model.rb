BablaViewModel = Struct.new(
  :query,
  :translations,
  keyword_init: true
) do
  def babla_url
    "https://pl.bab.la/slownik/polski-angielski/#{query}"
  end
end
