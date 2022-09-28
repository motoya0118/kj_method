class Users::RegistrationsController < ApplicationController
  def build_resource(hash={})
    hash[:uid] = User.create_unique_string
    super
  end
  def destroy
    current_user.destroy
    redirect_to top_path, notice: 'ユーザーを削除しました'
  end
end
