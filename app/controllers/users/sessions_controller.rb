class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    user = find_user

    if user&.valid_password?(password)
      sign_in(user)
      render_success
    else
      render_invalid_credentials
    end
  end

  private

  def find_user
    User.find_for_database_authentication(email: email)
  end

  def email
    params.dig(:user, :email)
  end

  def password
    params.dig(:user, :password)
  end

  def render_success
    render json: { message: 'Logged in successfully.', jwt: current_token }, status: :ok
  end

  def render_invalid_credentials
    render json: { error: 'Invalid email or password' }, status: :unauthorized
  end

  def current_token
    request.env['warden-jwt_auth.token']
  end

  def respond_with(_resource, _opts = {})
    render_success
  end

  def respond_to_on_destroy
    head :no_content
  end
end
