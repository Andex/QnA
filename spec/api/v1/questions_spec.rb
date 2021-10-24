require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do {   "CONTENT_TYPE" => "application/json",
                      "ACCEPT" => "application/json"  }   end
  let(:access_token) { create(:access_token) }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'api authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'api_check_public_fields' do
        let(:public_fields) { %w[id title body created_at updated_at] }
        let(:resource) { questions.first }
        let(:resource_response) { json['questions'].first }
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title and body' do
        expect(question_response['short_title']).to eq question.title.truncate(8)
        expect(question_response['short_body']).to eq question.body.truncate(10)
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq questions.size
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question, :with_reward, :with_files, :with_links, :with_comments) }

    it_behaves_like 'api authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: question.id) }
      let(:resource) { question }
      let(:resource_response) { json['question'] }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'api_check_public_fields' do
        let(:public_fields) { %w[id title body created_at updated_at] }
      end

      it_behaves_like 'api_check_contains_object' do
        let(:objects) { %w[user reward] }
      end

      it_behaves_like 'api_check_size_of_resource_list' do
        let(:resource_contents) { %w[comments files links] }
      end

      context 'question links' do
        it_behaves_like 'api_check_public_fields' do
          let(:resource) { question.links.first }
          let(:resource_response) { json['question']['links'].first }
          let(:public_fields) { %w[id name url created_at updated_at] }
        end
      end

      context 'question comments' do
        it_behaves_like 'api_check_public_fields' do
          let(:resource) { question.comments.first }
          let(:resource_response) { json['question']['comments'].first }
          let(:public_fields) { %w[id body user_id created_at updated_at] }
        end
      end

      it 'contains files url' do
        expect(json['question']['files'].first['url']).to eq Rails.application.routes.url_helpers.rails_blob_path(
                                                             question.files.first, only_path: true)
      end
    end
  end
end
