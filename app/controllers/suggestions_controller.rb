class SuggestionsController < ApplicationController
  def index
    host = "pl.wiktionary.org"
    path = "w/api.php"
    q = [
      "action=opensearch",
      "format=json",
      "formatversion=2",
      "search=#{query}",
      "namespace=0",
      "limit=10"
    ].join('&')
    xs = JSON.parse(get_or("https://#{host}/#{path}?#{q}", [nil, [query]])).second
    render json: xs
  end

  private

  def get_or(address, default)
    uri = URI::Parser.new.escape(address)
    Net::HTTP.get(URI(uri))
  rescue StandardError
    default
  end

  def query
    @query ||= params.fetch(:query)
  end
end
