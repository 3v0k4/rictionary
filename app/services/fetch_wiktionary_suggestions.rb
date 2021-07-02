class FetchWiktionarySuggestions
  HOST = "pl.wiktionary.org"
  PATH = "w/api.php"
  QUERY = [
    "action=opensearch",
    "format=json",
    "formatversion=2",
    "namespace=0",
    "limit=10",
  ]

  def initialize(http_client: HttpClient.new)
    @http_client = http_client
  end

  def call(query)
    JSON.parse(fetch(query)).second
  end

  private

  def fetch(query)
    q = [*QUERY, "search=#{query}"].join('&')
    default = [nil, [query]].to_json
    @http_client.get_or("https://#{HOST}/#{PATH}?#{q}", default)
  end
end
