Devise.setup do |config|
  config.http_authenticatable_on_xhr = false
  config.navigational_formats = ["*/*", :html, :json]
end

Devise.secret_key = "0e25221d7aa0757a5536c2f0c9a5aae4c9e422f67dc59ed8777e2810e620cf59bbe845b726864ce6f3b36e98f6c2157bd66d"