class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to mypage_path, notice: 'ゲストユーザーとしてログインしました。'
  end
  def admin_sign_in
    user = User.admin_user
    sign_in user
    redirect_to mypage_path, notice: 'Adminユーザーとしてログインしました。'
  end
end
