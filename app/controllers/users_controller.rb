class UsersController < ApplicationController
  def email
    @user = User.new
  end

  def set_email
    password = Devise.friendly_token[0, 20]

    @user = User.create!(email: email_params[:email], password: password, password_confirmation: password)

    @user.authorizations.create!(provider: session[:oauth_data]['provider'], uid: session[:oauth_data]['uid'])

    redirect_to root_path, alert: 'Your account successfully created! Please confirm your email!'
  end

  private

  def email_params
    params.require(:user).permit(:email)
  end
end