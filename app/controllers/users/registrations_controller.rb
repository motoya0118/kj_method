class Users::RegistrationsController < ApplicationController
  def build_resource(hash={})
    hash[:uid] = User.create_unique_string
    super
  end
end
