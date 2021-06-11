class LandingController < ApplicationController
  layout :layout

  def index
    @view_model = Fetch.new.call(query)
  end

  private

  def query
    @query ||= params.fetch(:query, "").strip
  end

  def layout
    @view_model.class == NoQueryViewModel ? "application" : "internal"
  end
end
