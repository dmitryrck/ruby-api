class NamesController < ApplicationController
  def index
    @names = Name.page(params[:page])
    render json: @names, only: %i[id name md5sum]
  end

  def create
    @name = Name.new(name_params)

    if @name.save
      render json: @name, only: %i[id name md5sum]
    else
      render json: @name.errors, status: :unprocessable_entity
    end
  end

  def update
    @name = Name.find(params[:id])

    if @name.update(name_params)
      render json: @name, only: %i[id name md5sum]
    else
      render json: @name.errors, status: :unprocessable_entity
    end
  end

  protected

  def name_params
    params.permit(:name, :md5sum)
  end
end
