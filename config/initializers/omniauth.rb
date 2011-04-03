require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :twitter, 'ZRNyeuetwQTYyXZ8CiCDg', 'Oyvq8eQZrSmB1wX8aEQRcWMBMDEAQml1FAtuMytjOVs'
  provider :open_id, OpenID::Store::Filesystem.new('/tmp')
end