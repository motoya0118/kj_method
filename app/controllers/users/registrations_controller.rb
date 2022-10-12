class Users::RegistrationsController < ApplicationController
  def build_resource(hash={})
    hash[:uid] = User.create_unique_string
    super
  end
  def destroy
    Card.acts_as_list_no_update do
      current_user.destroy
    end
    redirect_to top_path, notice: 'ユーザーを削除しました'
  end
end
