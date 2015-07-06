Devise::SessionsController.class_eval do
  respond_to :html, :json
  skip_before_action :verify_authenticity_token
end