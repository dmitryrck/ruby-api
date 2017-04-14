class TitlesController < ApplicationController
  def index
    @titles = Title.all
    render json: @titles
  end
end
