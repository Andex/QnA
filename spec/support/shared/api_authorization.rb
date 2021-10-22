shared_examples 'api authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end
    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: { access_token: '123' }, headers: headers)
      expect(response.status).to eq 401
    end
  end

  context 'authorized' do
    let(:access_token) { create(:access_token) }

    it 'returns 200 status' do
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      expect(response).to be_successful
    end
  end
end
