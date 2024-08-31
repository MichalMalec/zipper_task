class Users::SessionsController < Devise::SessionsController
    respond_to :json

    def create
        user = User.find_for_database_authentication(email: params[:user][:email])
        
        if user&.valid_password?(params[:user][:password])
          sign_in(user)
          render json: { message: 'Logged in successfully.', jwt: current_token }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

    private
  
    def respond_with(resource, _opts = {})
      render json: { message: 'Logged in successfully.', jwt: current_token }, status: :ok
    end

    def current_token
        request.env['warden-jwt_auth.token']
      end
  
    def respond_to_on_destroy
      head :no_content
    end
end
