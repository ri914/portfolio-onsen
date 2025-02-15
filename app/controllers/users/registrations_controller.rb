class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_guest_user, only: [:edit]

  def new
    @page_title = "新規登録"
    super
  end

  def edit
    @page_title = "アカウント設定"
  end

  def create
    super do |resource|
      if resource.persisted?
        flash[:notice] = t('devise.registrations.account_created')
      end
    end
  end

  def after_sign_up_path_for(resource)
    home_index_path
  end

  private

  def check_guest_user
    if current_user.guest?
      flash[:alert] = 'ゲストユーザーはこの機能を使用できません。'
      redirect_back(fallback_location: home_index_path)
    end
  end
end
