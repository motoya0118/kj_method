class TopsController < ApplicationController
  def top
  end
  def login
  end
  def mypage
    unless current_user
      redirect_to top_path, alert: '未ログインのため遷移できません'
    end
  end
  def confirm
  end
end
