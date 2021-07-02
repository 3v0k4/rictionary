class SuggestionsController < ApplicationController
  def index
    render json: FetchWiktionarySuggestions.new.call(query)
  end

  private

  def query
    @query ||= params.fetch(:query)
  end
end
