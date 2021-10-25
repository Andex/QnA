require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do {   "CONTENT_TYPE" => "application/json",
                      "ACCEPT" => "application/json"  }   end
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let!(:question) { create(:question) }

    it_behaves_like 'api unauthorizable'

    context 'authorized' do
      let(:answer_response) { json['answers'].first }
      let!(:answers) { create_list(:answer, 4, question: question) }
      let(:answer) { answers.first }
      let(:resource) { answer }
      let(:resource_response) { answer_response }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'api authorizable'

      it_behaves_like 'Checkable public fields' do
        let(:public_fields) { %w[id body created_at updated_at] }
      end

      it_behaves_like 'Checkable contains object' do
        let(:objects) { %w[user question] }
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq answers.size
      end
    end
  end

  describe 'GET /api/v1/questions/:id/answers/:id' do
    let(:method) { :get }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, :with_files, :with_links, :with_comments, question: question) }

    it_behaves_like 'api unauthorizable'

    context 'authorized' do
      let(:answer_response) { json['answer'] }
      let(:resource) { answer }
      let(:resource_response) { answer_response }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'api authorizable'

      it_behaves_like 'Checkable public fields' do
        let(:public_fields) { %w[id body created_at updated_at] }
      end

      it_behaves_like 'Checkable contains object' do
        let(:objects) { %w[user question] }
      end

      it_behaves_like 'Checkable size of resource list' do
        let(:resource_contents) { %w[comments files links] }
      end

      context 'answer links' do
        it_behaves_like 'Checkable public fields' do
          let(:resource) { answer.links.first }
          let(:resource_response) { answer_response['links'].first }
          let(:public_fields) { %w[id name url created_at updated_at] }
        end
      end

      context 'answer comments' do
        it_behaves_like 'Checkable public fields' do
          let(:resource) { answer.comments.first }
          let(:resource_response) { answer_response['comments'].first }
          let(:public_fields) { %w[id body user_id created_at updated_at] }
        end
      end

      it 'contains files url' do
        expect(answer_response['files'].first['url']).to eq Rails.application.routes.url_helpers.rails_blob_path(
                                                            answer.files.first, only_path: true)
      end
    end
  end
end
