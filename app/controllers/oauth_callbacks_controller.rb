class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    connect_to('Github')
  end

  def vkontakte
    connect_to('Vkontakte')
  end

  def connect_to(provider)
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif @user.nil? && !auth.nil?
      # Removing extra as it can overflow some session stores
      session['oauth_data'] = auth.except('extra')
      redirect_to email_path, alert: 'Your email not found, you need register with set email.'
    else
      redirect_to new_user_registration_path, alert: 'Something went wrong. Please try again later.'
    end
  end

  # def failure
  #   redirect_to new_user_registration_path
  # end
end