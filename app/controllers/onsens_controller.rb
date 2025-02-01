class OnsensController < ApplicationController
  before_action :authenticate_user!

  def new
    @onsen = Onsen.new
  end

  def create
    @onsen = current_user.onsens.build(onsen_params)
    if @onsen.save
      redirect_to @onsen, notice: t('notices.onsen_created')
    else
      render :new
    end
  end

  def save
    @onsen = Onsen.find(params[:id])
    @onsen.saved_by_user_id = current_user.id
    if @onsen.save
      redirect_to @onsen, notice: t('notices.onsen_saved')
    else
      redirect_to @onsen, alert: t('alerts.onsen_save_failed')
    end
  end

  private

  def onsen_params
    params.require(:onsen).permit(:name, :location, :description, :image)
  end
end
