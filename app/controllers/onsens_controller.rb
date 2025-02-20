class OnsensController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest_user, only: [:new, :create]

  def index
    @onsens = Onsen.all
    @onsens = Onsen.order(:location, :name)
    @current_region = 'トップ'
  end

  def region
    @region = params[:region]
    @onsens = Onsen.where(location: Onsen.region_locations(@region))
    @region = Onsen.order(:location, :name)
    @current_region = params[:region]
    @prefectures = Onsen.region_locations(@region)
  end

  def prefecture
    @prefecture = params[:prefecture]
    @onsens = Onsen.where(location: @prefecture).order(:name)
  end

  def show
    @onsen = Onsen.includes(:water_qualities, :image_descriptions).find(params[:id])
    @user = current_user
    @saved_onsens = @user.saved_onsens.includes(:onsen) if @user
    @posted_onsens = @user.onsens if @user
  end

  def new
    @onsen = Onsen.new
  end

  def create
    unless current_user
      flash[:alert] = 'ログインしてください。'
      redirect_to new_user_session_path and return
    end

    @onsen = current_user.onsens.build(onsen_params)

    if Onsen.exists?(name: @onsen.name)
      flash[:alert] = 'この温泉地は既に投稿されています。'
      render :new and return
    end

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
      flash.now[:alert] = '温泉の投稿に失敗しました。'
      render :new
    end
  end

  def bookmark
    @onsen = Onsen.find(params[:onsen_id])
    saved_onsen = SavedOnsen.find_or_initialize_by(user: current_user, onsen: @onsen)

    if saved_onsen.new_record?
      saved_onsen.save
      saved = true
    else
      saved_onsen.destroy
      saved = false
    end

    respond_to do |format|
      format.json { render json: { saved: saved } }
      format.html { redirect_to onsens_path }
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
