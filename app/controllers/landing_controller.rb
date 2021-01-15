class LandingController < ApplicationController
  def index
    @translations = translations
    @examples = examples
    @images = images
  end

  private

  def query
    @query ||= params.fetch(:query, nil)
  end

  def translations
    return [] if query.nil?

    host = "pl.wiktionary.org"
    path = "api/rest_v1/page/html/#{query}"
    uri = URI(URI::Parser.new.escape("https://#{host}/#{path}"))
    html = Net::HTTP.get(uri)
    ParseHtml.new.call(html).translations
  end

  def examples
    return [] if query.nil?

    host = "pl.wiktionary.org"
    path = "api/rest_v1/page/html/#{query}"
    uri = URI(URI::Parser.new.escape("https://#{host}/#{path}"))
    html = Net::HTTP.get(uri)
    ParseHtml.new.call(html).examples
  end

  def images
    return [] if query.nil?

    host = "pl.wiktionary.org"
    path = "api/rest_v1/page/html/#{query}"
    uri = URI(URI::Parser.new.escape("https://#{host}/#{path}"))
    html = Net::HTTP.get(uri)
    ParseHtml.new.call(html).images
  end
end
