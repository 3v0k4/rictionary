class CorrectQueryViaBabla
  def call(query)
    fetch(query.gsub(" ", "+"))
      .map { |suggestion| suggestion.fetch("value") }
      .find { |suggestion| suggestion.size == query.size }
  end

  private

  def fetch(query)
    uri = URI.parse("https://bab.la/ax/dictionary/ta")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded; charset=UTF-8"
    request.set_form_data(d: "enpl", q: query)
    req_options = { use_ssl: uri.scheme == "https" }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    JSON.parse(response.body)
  rescue StandardError
    []
  end
end
