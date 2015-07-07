Spree::UserSessionsController.class_eval do
  def create
    resource = Spree::User.find_for_database_authentication(:email => params[:spree_user][:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:spree_user][:password])
      sign_in(:spree_user, resource)
      resource.ensure_authentication_token!
      render :json=> { success: true, auth_token: resource.authentication_token, spree_api_key: resource.spree_api_key, email: resource.email }
      return
    end
    invalid_login_attempt
  end
end