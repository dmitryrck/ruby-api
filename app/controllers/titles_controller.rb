class TitlesController < ApplicationController
  def index
    @titles = Title.order("id desc").page(params[:page])
    render json: @titles, only: %i[id title production_year], include: :kind
  end

  def create
    @title = Title.new(title_params)

    if @title.save
      render json: @title, only: %i[id title production_year], include: :kind
    else
      render json: @title.errors, status: :unprocessable_entity
    end
  end

  def update
    @title = Title.find(params[:id])

    if @title.update(title_params)
      render json: @title, only: %i[id title production_year], include: :kind
    else
      render json: @title.errors, status: :unprocessable_entity
    end
  end

  protected

  def title_params
    params.permit(:title, :kind_id, :production_year)
  end
end
