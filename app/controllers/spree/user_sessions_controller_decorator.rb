Spree::UserSessionsController.class_eval do
  respond_to :html, :json

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

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield if block_given?
    respond_to_on_destroy
  end

  private

  def respond_to_on_destroy
    respond_to do |format|
      format.all { head :no_content }
      format.json { render :json => { session: 'destroyed' } }
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
    end
  end
end