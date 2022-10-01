class TopsController < ApplicationController
  before_action :authenticate_user!, only:[:mypage, :confirm]
  def top
  end
  def login
  end
  def mypage
  end
  def confirm
  end
  def about
  end
end
