class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :reject_guest_user, only: [:update, :destroy]

  def show
    @saved_onsens = @user.saved_onsens
    @posted_onsens = @user.onsens
    @page_title = "マイページ"
  end

  def update
    if @user.valid_password?(params[:user][:current_password])
      @user.avatar.purge if params[:user][:remove_avatar] == "1"

      if @user.update(params.require(:user).permit(:name, :avatar))
        redirect_to user_path(@user), notice: t('devise.registrations.account_updated')
      else
        render 'devise/registrations/edit'
      end
    else
      flash[:alert] = t('devise.registrations.invalid_current_password')
      render 'devise/registrations/edit'
    end
  end

  def destroy
    @user.onsens.destroy_all if @user.onsens.present?
    @user.destroy
    redirect_to root_path, notice: t('devise.registrations.account_deleted')
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def reject_guest_user
    if @user.guest?
      redirect_to home_index_path, alert: t('alerts.guest_user')
    end
  end

  def user_params
    params.require(:user).permit(:email, :name, :avatar, :password, :password_confirmation, :current_password)
  end
end
