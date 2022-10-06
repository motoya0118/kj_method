class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @user = User.find_for_twitter(request.env['omniauth.auth'])
    binding.pry
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "twitter") if is_navigational_format?
    else
      session['devise.twitter_data'] = request.env['omniauth.auth'].except("extra")
      redirect_to login_path, notice: "ログインに失敗しました。"
    end
  end
end