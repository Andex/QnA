require 'rails_helper'

describe 'Users API', type: :request do
  let(:headers) do {   "CONTENT_TYPE" => "application/json",
                      "ACCEPT" => "application/json"  }   end
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /api/v1/users/me' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/users/me' }

    it_behaves_like 'api unauthorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'api authorizable'

      it_behaves_like 'Checkable public fields' do
        let(:public_fields) { %w[id email admin created_at updated_at] }
        let(:resource) { me }
        let(:resource_response) { json['user'] }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/users' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/users' }

    it_behaves_like 'api unauthorizable'

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'api authorizable'

      it 'returns list of users except me' do
        expect(json['users'].size).to eq users.size
      end

      it 'not returns me in list of users' do
        json['users'].each do |user|
          expect(user['id']).to_not eq me.id
        end
      end

      it_behaves_like 'Checkable public fields' do
        let(:public_fields) { %w[id email admin created_at updated_at] }
        let(:resource) { users.first }
        let(:resource_response) { json['users'].first }
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
