class ApplicationController < ActionController::Base
  include ApplicationHelper
  def after_sign_in_path_for(resource)
    if session['url']
      session['url']
    else
      mypage_path
    end
  end
end
