class LandingController < ApplicationController
  def index
    @translations = translations
    @examples = examples
    @images = images
    @declination = declination
    @conjugation = conjugation
  end

  private

  def query
    @query ||= params.fetch(:query, nil)
  end

  def parsed
    return @parsed if @parsed

    host = "pl.wiktionary.org"
    path = "api/rest_v1/page/html/#{query}"
    uri = URI(URI::Parser.new.escape("https://#{host}/#{path}"))
    html = Net::HTTP.get(uri)
    @parsed = ParseHtml.new.call(html)
  end

  def translations
    return [] if query.nil?
    parsed.translations
  end

  def examples
    return [] if query.nil?
    parsed.examples
  end

  def images
    return [] if query.nil?
    parsed.images
  end

  def declination
    return if query.nil?
    parsed.declination
  end

  def conjugation
    return if query.nil?
    parsed.conjugation
  end
end
