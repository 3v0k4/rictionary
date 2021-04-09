class LandingController < ApplicationController
  def index
    @view_model = Fetch.new.call(query)
  end

  private

  def query
    @query ||= params.fetch(:query, "").strip
  end
end
