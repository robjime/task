class V1::SessionsController < Devise::SessionsController
  # https://github.com/plataformatec/devise/blob/master/app/controllers/devise/sessions_controller.rb

  # POST /user/sign_in
  def create
   #checks username and password
   self.resource = warden.authenticate!(auth_options)
   sign_in(resource_name, resource)
   
   #verify the client is valid
   if(Client.exists?(client_token: params[:client][:client_token]))
     #check for existing token
     #TODO move this check to token controller and automatically assign to token ? nil
     @token = Token.select(:authentication_token).where(user_id: current_user.id).joins(:client).where(clients: {client_token: params[:client][:client_token]})
     if(@token.empty?)
       #if no token already is assigned, assign a token
       token = Token.new(:authentication_token => Devise.friendly_token, :user_id => current_user.id, :client_id => Client.where(client_token: params[:client][:client_token]).take!.id)
       token.save
     else
       #if token alread assigned, return token
       token = @token.take!
     end
     respond_to do |format|
         format.json {
           render :json => {
             :user_id => current_user.id,
             :authentication_token => token.authentication_token
          }.to_json, :status => :ok
        }
     end
   end
  end

  # DELETE /user/sign_out
  def destroy 
   respond_to do |format|
     format.json {
       current_token = authenticate_user_from_token!
       if(current_token)
         if(current_user)
           #if we are a valid user, delete current token from token table
           #TODO move this to token controller destroy
           Token.delete(current_token.id)
           render :json => {:default_message=>"Successfully signed out."}.to_json, :status => :ok
         else
           #technically we should get here, because current_user is only set if the user is authenticated
           render :json => {:default_message=>"Something went wrong. (User not found)"}.to_json, :status => :unprocessable_entity
         end
         signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
       else
         #Must be valid user and signed in to sign out
         render :json => {:default_message=>"Something went wrong."}.to_json, :status => :unprocessable_entity
       end
      }
    end
  end
end