module ApplicationHelper
  def make_user!(thema_id)
    if user_signed_in?
      thema = Thema.find(thema_id)
      unless current_user.id == thema.user_id
        redirect_to mypage_path, alert: 'テーマ作成ユーザー以外閲覧不可です'
      end
    else
      redirect_to login_path
    end
  end
end
