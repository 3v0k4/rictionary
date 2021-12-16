Found = Struct.new(
  :corrected,
  :translations,
  keyword_init: true
) do
  def nil? = false
  def babla_url = "#{URL}/#{corrected}"
end
