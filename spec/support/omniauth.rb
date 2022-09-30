OmniAuth.config.test_mode = true

#OmniAuth.config.mock_auth[:twitter] =OmniAuth::AuthHash.new()
#test側で　Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
  provider: 'twitter', 
  uid: '12345', 
  info: { email: 'test1@example.com',
          :nickname => "fuga",
          :name => "hoge", }, 
  credentials: { token: '1234qwer' },
)

# $users << OmniAuth::AuthHash.new(
#   provider: 'twitter', 
#   uid: '12346', 
#   info: { email: 'motoya@gmail.com',
#           :nickname => "puchanpig",
#           :name => "motoya", }, 
#   credentials: { token: '1234qwef' },
# )

# $users << OmniAuth::AuthHash.new(
#   provider: 'twitter', 
#   uid: '12347', 
#   info: { email: 'test@gmail.com',
#           :nickname => "100p",
#           :name => "test", }, 
#   credentials: { token: '1234qwea' },
# )