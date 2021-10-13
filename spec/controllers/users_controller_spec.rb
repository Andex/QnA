require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'Get #email' do
    before { get :email }

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders email view' do
      expect(response).to render_template :email
    end
  end

  describe 'Post #set_email' do
    let!(:oauth_data) { { 'provider' => 'provider', 'uid' => 123 } }

    before { session[:oauth_data] = oauth_data }

    it 'create a new user' do
      expect{ post :set_email, params: { user: attributes_for(:user) } }.to change(User, :count).by(1)
    end

    it 'create a new authorization' do
      expect do
        post :set_email, params: { user: attributes_for(:user),
                                   provider: session[:oauth_data]['provider'],
                                   uid: session[:oauth_data]['uid'] }
      end.to change(Authorization, :count).by(1)
    end

    it 'redirects to root' do
      post :set_email, params: { user: attributes_for(:user) }
      expect(response).to redirect_to root_path
    end
  end
end
