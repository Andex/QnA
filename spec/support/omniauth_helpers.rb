module OmniauthHelpers
  # Включить тестовый режим
  OmniAuth.config.test_mode = true

  def mock_auth_hash(provider, email:)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({
                                                                          'provider' => provider,
                                                                          'uid' => '123545',
                                                                          'info' => {
                                                                            'email' => email
                                                                          },
                                                                          'credentials' => {
                                                                            'token' => 'mock_token',
                                                                            'secret' => 'mock_secret'
                                                                          }
                                                                        })
  end

  def invalid_mock(provider)
    # Если установить макет провайдера на символ вместо хэша, он передаст это сообщение
    # redirected back to /auth/failure?message=invalid_credentials.
    OmniAuth.config.mock_auth[provider.to_sym] = :invalid_credentials
  end
end