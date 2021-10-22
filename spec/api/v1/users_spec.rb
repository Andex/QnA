require 'rails_helper'

describe 'Users API', type: :request do
  let(:headers) { {   "CONTENT_TYPE" => "application/json",
                      "ACCEPT" => "application/json"  }   }

  describe 'GET /api/v1/users/me' do
    it_behaves_like 'api authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/users/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/users/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/users' do
    it_behaves_like 'api authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/users' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:user) { users.first }
      let(:users_response) { json['users'].first }

      before { get '/api/v1/users', params: { access_token: access_token.token }, headers: headers }

      it 'returns list of users except me' do
        expect(json['users'].size).to eq users.size
      end

      it 'not returns me in list of users' do
        json['users'].each do |user|
          expect(user['id']).to_not eq me.id
        end
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(users_response[attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          json['users'].each do |user|
            expect(user).to_not have_key(attr)
          end
        end
      end
    end
  end
end
