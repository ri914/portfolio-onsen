class OnsensController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:sort] == "bookmarks"
      location_order_sql = Onsen.prefecture_order.map { |pref, order| "WHEN '#{pref}' THEN #{order}" }.join(' ')

      @onsens = Onsen.
        left_joins(:saved_onsens).
        group('onsens.id').
        select('onsens.*, COUNT(saved_onsens.id) AS bookmarks_count').
        order(Arel.sql("COUNT(saved_onsens.id) DESC, CASE onsens.location #{location_order_sql} ELSE 999 END, onsens.id ASC"))
    else
      @onsens = Onsen.all.sort_by do |onsen|
        [
          Onsen.region_order[onsen.region],
          Onsen.prefecture_order[onsen.location],
        ]
      end
    end

    @current_region = '全国'
    @page_title = "全国の温泉"
  end

  def region
    @region = params[:region]
    @current_region = @region
    @prefectures = Onsen.region_locations(@region)

    if params[:sort] == "bookmarks"
      location_order_sql = Onsen.prefecture_order.map { |pref, order| "WHEN '#{pref}' THEN #{order}" }.join(' ')

      @onsens = Onsen.where(location: @prefectures).
        left_joins(:saved_onsens).
        group('onsens.id').
        select('onsens.*, COUNT(saved_onsens.id) AS bookmarks_count').
        order(Arel.sql("COUNT(saved_onsens.id) DESC, CASE onsens.location #{location_order_sql} ELSE 999 END, onsens.id ASC"))
    else
      @onsens = Onsen.where(location: @prefectures).sort_by do |onsen|
        Onsen.prefecture_order[onsen.location]
      end
    end

    @page_title = "#{@region}の温泉"
  end

  def prefecture
    @prefecture = params[:prefecture]
    @onsens = Onsen.where(location: @prefecture)

    if params[:sort] == "bookmarks"
      @onsens = Onsen.where(location: @prefecture).
        left_joins(:saved_onsens).
        group('onsens.id').
        select('onsens.*, COUNT(saved_onsens.id) AS bookmarks_count').
        order(Arel.sql("COUNT(saved_onsens.id) DESC, onsens.id ASC"))
    else
      @onsens = Onsen.where(location: @prefecture).order(:id)
    end

    @page_title = "#{@prefecture}の温泉"
  end

  def show
    @onsen = Onsen.includes(:water_qualities, :image_descriptions).find(params[:id])
    @user = current_user
    @saved_onsens = @user.saved_onsens.includes(:onsen) if @user
    @posted_onsens = @user.onsens if @user

    @page_title = @onsen.name

    @weather = WeatherService.fetch_weather_for(@onsen.location)
  end

  def new
    @onsen = Onsen.new

    @page_title = "投稿ページ"
  end

  def edit
    @onsen = Onsen.find(params[:id])
    @new_images = params[:onsen] ? params[:onsen][:images] : []

    @page_title = "温泉情報設定"
  end

  def create
    unless current_user
      flash[:alert] = I18n.t('alerts.login_required')
      redirect_to new_user_session_path && return
    end

    @onsen = current_user.onsens.build(onsen_params)

    existing_onsen = Onsen.find_by(name: onsen_params[:name], location: onsen_params[:location])

    if existing_onsen
      @error_message = I18n.t('alerts.onsen_already_exists')
      render :new
      return
    end

    if @onsen.save
      if params[:onsen][:new_descriptions].present?
        params[:onsen][:new_descriptions].each_with_index do |description, index|
          if @onsen.images.attached? && index < @onsen.images.count
            @onsen.image_descriptions.create(description: description)
          end
        end
      end

      redirect_to @onsen, notice: I18n.t('notices.onsen_created')
    else
      flash.now[:alert] = I18n.t('alerts.post_failed')
      render :new
    end
  end

  def update
    unless current_user
      flash[:alert] = I18n.t('alerts.login_required')
      redirect_to new_user_session_path && return
    end

    @onsen = Onsen.find(params[:id])

    existing_onsen = Onsen.where.not(id: @onsen.id).find_by(name: onsen_params[:name], location: onsen_params[:location])
    if existing_onsen
      @error_message = I18n.t('alerts.onsen_already_exists')
      render :edit
      return
    end

    new_images = params[:onsen][:images].compact_blank if params[:onsen][:images].present?
    new_descriptions = params[:onsen][:new_descriptions].compact_blank if params[:onsen][:new_descriptions].present?

    if @onsen.update(onsen_params.except(:images, :image_descriptions))
      if new_images.present?
        @onsen.images.destroy_all
        @onsen.image_descriptions.destroy_all
        @onsen.images.attach(new_images)

        if new_descriptions.present?

          new_descriptions.each_with_index do |description, index|
            if @onsen.images.attached? && index < @onsen.images.count
              @onsen.image_descriptions.create(description: description)
            end
          end
        end
      end

      redirect_to @onsen, notice: I18n.t('notices.onsen_updated')
    else
      flash.now[:alert] = I18n.t('alerts.update_failed')
      render :edit
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

    bookmarked_count = @onsen.saved_onsens.count

    respond_to do |format|
      format.json { render json: { saved: saved, bookmarked_count: bookmarked_count } }
      format.html { redirect_to onsens_path }
    end
  end

  def bookmarked
    if params[:sort] == "bookmarks"
      @onsens = current_user.saved_onsens.
        includes(:onsen).
        map(&:onsen).
        sort_by { |onsen| -onsen.saved_onsens.count }
    else
      @onsens = current_user.saved_onsens.
        includes(:onsen).
        map(&:onsen).
        sort_by do |onsen|
        [Onsen.region_order[onsen.region], Onsen.prefecture_order[onsen.location]]
      end
    end

    @page_title = "保存済みの温泉"
  end

  def destroy
    @onsen = Onsen.find(params[:id])

    if @onsen.destroy
      redirect_to onsens_path, notice: I18n.t('notices.onsen_deleted')
    else
      redirect_to onsens_path, alert: I18n.t('alerts.delete_failed')
    end
  end

  def search
    @keyword = params[:keyword]

    if @keyword.present?
      @onsens = Onsen.where("onsens.name LIKE ?", "%#{@keyword}%").distinct
    else
      @onsens = []
    end

    @onsens = @onsens.sort_by do |onsen|
      [
        Onsen.region_order[onsen.region],
        Onsen.prefecture_order[onsen.location],
      ]
    end.uniq

    @page_title = "検索結果"
  end

  def detail_search
    @locations = Onsen.prefectures
    @water_qualities = WaterQuality.all

    @page_title = "詳細検索"
  end

  def search_with_details
    @keyword = params[:keyword]
    @location = params[:location]
    @water_quality_ids = params[:water_quality_ids].compact_blank

    @onsens = Onsen.all

    if @keyword.present?
      @onsens = @onsens.where("onsens.name LIKE ?", "%#{@keyword}%").distinct
    end

    if @location.present?
      @onsens = @onsens.where(location: @location)
    end

    if @water_quality_ids.present?
      @onsens = @onsens.joins(:water_qualities).where(water_qualities: { id: @water_quality_ids })
    end

    @onsens = @onsens.to_a

    @onsens = @onsens.sort_by do |onsen|
      [
        Onsen.region_order[onsen.region],
        Onsen.prefecture_order[onsen.location],
      ]
    end.uniq

    render 'search'
  end

  def roten
    @onsens = Onsen.all

    valid_weather_conditions = ['晴天']

    @onsens = @onsens.select do |onsen|
      weather = WeatherService.fetch_weather_for(onsen.location)
      weather && valid_weather_conditions.include?(weather[:description])
    end

    @page_title = "露天日和"
  end

  private

  def onsen_params
    params.require(:onsen).permit(
      :name,
      :location,
      water_quality_ids: [],
      images: [],
      image_descriptions: []
    )
  end
end
