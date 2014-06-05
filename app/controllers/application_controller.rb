class ApplicationController  < ActionController::Base
  skip_before_filter  :verify_authenticity_token
  # Prevent CSRF attacks by raising an exception.
  #protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }
  
  before_filter do
    # Apply strong_parameters filtering before CanCan authorization
    # See https://github.com/ryanb/cancan/issues/571#issuecomment-10753675
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  
    #require token for anything that inherits this class
    authenticate_user_from_token!
  end
  
  rescue_from CanCan::AccessDenied do |exception|  
    render :json => {
         :default_message=>"You are not authorized."
         }, status: :forbidden
  end
  
  current_token = nil
  
  private 
  def authenticate_user_from_token!
    #TODO add signature for parameters
    user_email = params[:user][:email].presence
    @tokens = user_email && User.joins(:tokens).select("*").where(users: {email: user_email})
    
    @tokens.each do |token|
      # Notice how we use Devise.secure_compare to compare the token
      # in the database with the token given in the params, mitigating
      # timing attacks.
      #TODO the check for token here is unnecessary 
      if token && Devise.secure_compare(token.authentication_token, params[:authentication_token])
        #TODO clean up so we only have to call one query
        user = User.find(token.user_id)
        sign_in user, store: false
        current_token = token
        return current_token
      end
    end
    #TODO throw to unauthorized response
    logger.debug "Forbidden"
    return false
  end
end