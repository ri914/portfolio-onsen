class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
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

  private

  def user_params
    params.require(:user).permit(:email, :name, :avatar, :password, :password_confirmation, :current_password)
  end
end
