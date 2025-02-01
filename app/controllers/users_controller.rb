class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @saved_onsens = @user.saved_onsens
    @posted_onsens = @user.onsens
  end

  def update
    @user = User.find(params[:id])

    if params[:user][:remove_avatar] == "1"
      @user.avatar.purge
    end

    if @user.update(params.require(:user).permit(:name, :avatar))
      redirect_to user_path(@user), notice: t('devise.registrations.account_updated')
    else
      render 'devise/registrations/edit'
    end
  end

  def destroy
    @user = current_user

    if @user.guest?
      redirect_to request.referer || root_path, alert: t('devise.registrations.guest_account_deletion_error')
      return
    end

    @user.onsens.destroy_all if @user.onsens.present?

    @user.destroy
    redirect_to root_path, notice: t('devise.registrations.account_deleted')
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :avatar, :password, :password_confirmation, :current_password)
  end
end
