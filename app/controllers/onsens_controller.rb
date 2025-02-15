class OnsensController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest_user, only: [:new, :create]

  def show
    @onsen = Onsen.includes(:water_qualities, :image_descriptions).find(params[:id])
  end

  def new
    @onsen = Onsen.new
  end

  def create
    @onsen = current_user.onsens.build(onsen_params)

    if Onsen.exists?(name: @onsen.name)
      flash[:alert] = 'この温泉地は既に投稿されています。'
      render :new and return
    end

    if @onsen.save
      if params[:onsen][:image_descriptions].present?
        params[:onsen][:image_descriptions].each_with_index do |description, index|
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

  def check_guest_user
    if current_user.guest?
      flash[:alert] = 'ゲストユーザーはこの機能を使用できません。'
      redirect_back(fallback_location: home_index_path)
    end
  end

  def onsen_params
    params.require(:onsen).permit(:name, :location, :description, images: [], water_quality_ids: [])
  end
end
