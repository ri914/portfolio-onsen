class Users::SessionsController < Devise::SessionsController
  def new
    @page_title = "ログイン"
    super
  end

  def guest_login
    guest_user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'ゲストユーザー'
    end

    sign_in guest_user
    keyword = params[:keyword]

    if keyword.present?
      redirect_to search_onsens_path(keyword: keyword), notice: t('devise.sessions.guest_logged_in')
    else
      redirect_to home_index_path, notice: t('devise.sessions.guest_logged_in')
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to root_path, alert: "ゲストログインに失敗しました: #{e.message}"
  end

  def after_sign_in_path_for(resource)
    home_index_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
