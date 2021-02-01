class LandingController < ApplicationController
  def index
    @view_model = Fetch.new.call(query)
    @language = language
  end

  private

  def query
    @query ||= params.fetch(:query, "")
  end

  def language
    @language ||= params.fetch(:language, "")
  end
end
