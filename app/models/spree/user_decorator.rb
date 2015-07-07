Spree.user_class.class_eval do
  def ensure_authentication_token!
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless Spree::User.where(authentication_token: token).first
    end
  end
end