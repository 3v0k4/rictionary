class CorrectQueryViaWiktionary
  HOST = "pl.wiktionary.org"
  PATH = "w/api.php"
  PARAMS = [
    "action=opensearch",
    "format=json",
    "formatversion=2",
    "namespace=0%7C100%7C102",
    "limit=10"
  ]

  def initialize(http_client: HttpClient.new)
    @http_client = http_client
  end

  def call(query)
    fetch(query)
      .second
      .find { |suggestion| suggestion.size == query.size }
  end

  private

  def fetch(query)
    q = [ *PARAMS, "search=#{query}" ].join("&")
    url = "https://#{HOST}/#{PATH}?#{q}"
    default = [ nil, [ query ] ].to_json
    JSON.parse(@http_client.get_or(url, default))
  end
end
