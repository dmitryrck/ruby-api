class TitlesController < ApplicationController
  def index
    @titles = Title.page(params[:page])
    render json: @titles
  end

  def create
    @title = Title.new(title_params)
    if @title.save
      render json: @title
    else
      render json: @title.errors, status: :bad_request
    end
  end

  def update
    @title = Title.find(params[:id])

    if @title.update(title_params)
      render json: @title
    else
      render json: @title.errors, status: :bad_request
    end
  end

  protected

  def title_params
    params.permit(:title, :kind_id, :production_year)
  end
end
