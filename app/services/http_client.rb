class HttpClient
  def get_or(address, default)
    get_or_redirect(->(_) { address }, nil, default)
  end

  def get_or_redirect(uri_builder, query, default)
    uri = URI(URI::Parser.new.escape(uri_builder.call(query)))
    response = Net::HTTP.get_response(uri)
    if response.code == '302'
      new_query = URI::Parser.new.unescape(response['location'])
      return get_or_redirect(uri_builder, new_query, default)
    end
    response.body
  rescue StandardError
    default
  end
end
