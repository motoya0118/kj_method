class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:omniauthable, omniauth_providers: %i(twitter)
  
  has_many :places
  has_many :themas, dependent: :destroy
  has_many :answers, dependent: :destroy
  

  def self.create_unique_string
    SecureRandom.uuid
  end

  def self.find_for_twitter(auth)
    user = User.find_by(email: auth.info.email)
  
    unless user
      user = User.new(name: auth.info.name,
                      nickname: auth.info.nickname,
                      email: auth.info.email,
                      provider: auth.provider,
                      uid:      auth.uid,
                      password: Devise.friendly_token[0, 20],
                                   )
    end
    user.save
    user
  end
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'hoge'
      user.nickname = 'fuga'
    end
  end
  def self.admin_user
    find_or_create_by!(email: 'admin@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'taro'
      user.nickname = 'admin'
      user.admin = true
    end
  end
end
