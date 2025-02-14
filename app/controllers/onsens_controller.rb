class OnsensController < ApplicationController
  before_action :authenticate_user!

  def show
    @onsen = Onsen.includes(:water_qualities, :image_descriptions).find(params[:id])
  end

  def new
    @onsen = Onsen.new
  end

  def create
    @onsen = current_user.onsens.build(onsen_params)
    if @onsen.save
      if params[:onsen][:descriptions].present?
        params[:onsen][:descriptions].each_with_index do |description, index|
          if index < @onsen.images.size
            @onsen.image_descriptions.create(description: description)
          end
        end
      end
      redirect_to @onsen, notice: t('notices.onsen_created')
    else
      render :new
    end
  end

  private

  def onsen_params
    params.require(:onsen).permit(:name, :location, :description, images: [], water_quality_ids: [])
  end
end
