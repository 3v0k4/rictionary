Found = Struct.new(
  :corrected,
  :translations,
  keyword_init: true
) do
  def nil? = false
  def babla_url = "https://pl.bab.la/slownik/polski-angielski/#{corrected}"
end
