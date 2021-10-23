require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { {   "CONTENT_TYPE" => "application/json",
                      "ACCEPT" => "application/json"  }   }
  let(:access_token) { create(:access_token) }

  describe 'GET /api/v1/questions/:id/answers' do
    let!(:question) { create(:question) }

    it_behaves_like 'api authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'authorized' do
      let(:answer_response) { json['answers'].first }
      let!(:answers) { create_list(:answer, 4, question: question) }
      let(:answer) { answers.first }
      let(:resource) { answer }
      let(:resource_response) { answer_response }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'api_check_public_fields' do
        let(:public_fields) { %w[id body created_at updated_at] }
      end

      it_behaves_like 'api_check_contains_object' do
        let(:objects) { %w[user question] }
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq answers.size
      end
    end
  end
end
