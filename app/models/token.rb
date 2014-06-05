class Token < ActiveRecord::Base
	belongs_to :client
	belongs_to :users
	
	# You likely have this before callback set up for the token.
  before_save :ensure_authentication_token
 
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end
 
  private
  
  #sets the auth token on save
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless Token.where(authentication_token: token).first
    end
  end
end