class LandingController < ApplicationController
  def index
    @parse_result = query.nil? ? empty : parsed
  end

  private

  def query
    @query ||= params.fetch(:query, nil)
  end

  def empty
    ParseResult.new(
      translations: [],
      examples: [],
      images: [],
      declination: nil,
      conjugation: nil
    )
  end

  def parsed
    host = "pl.wiktionary.org"
    path = "api/rest_v1/page/html/#{query}"
    uri = URI(URI::Parser.new.escape("https://#{host}/#{path}"))
    html = Net::HTTP.get(uri)
    ParseHtml.new.call(html)
  end
end
