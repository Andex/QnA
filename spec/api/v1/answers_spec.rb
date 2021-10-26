require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
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

  describe 'POST /api/v1/answers' do
    let!(:question) { create(:question) }
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    
    it_behaves_like 'api unauthorizable'

    context 'authorized' do
      context 'with valid attributes' do
        let(:answer) { attributes_for(:answer, question: question) }
        let(:answer_response) { json['answer'] }

        it 'creates a new Answer' do
          expect{ post api_path, params: { access_token: access_token.token, answer: answer },
          headers: headers }.to change(Answer, :count).by(1)
        end

        before do
          post api_path,
               params: { access_token: access_token.token, answer: answer },
               headers: headers
        end

        it_behaves_like 'api authorizable'
    
        it 'contains user object' do
          expect(answer_response['user']['id']).to eq access_token.resource_owner_id
        end
  
        it 'creates a answer with the correct attributes' do
          expect(Answer.last).to have_attributes answer
        end
      end
    
      context 'with invalid attributes' do
        let(:answer) { attributes_for(:answer, :invalid, question: question) }
    
        it "doesn't save answer, renders errors" do
          expect { post api_path, params: { access_token: access_token.token, answer: answer },
          headers: headers }.to_not change(Answer, :count)
        end

        before do
          post api_path,
               params: { access_token: access_token.token, answer: answer },
               headers: headers
        end

        it 'returns status 422' do
          expect(response.status).to eq 422
        end

        it 'returns error' do
          expect(json['errors']).to_not be_nil
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, :with_files, :with_links, user: user, question: question) }
    let(:method) { :patch }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'api unauthorizable'

    context 'authorized' do
      context 'author' do
        context 'with valid attributes' do
          let(:answer_response) { json['answer'] }

          before do
            patch api_path,
                params: { access_token: access_token.token,
                          answer: { body: 'new body' } },
                headers: headers
          end

          it_behaves_like 'api authorizable'

          it 'contains user object' do
            expect(answer_response['user']['id']).to eq access_token.resource_owner_id
          end

          it 'changes answer attributes' do
            answer.reload

            expect(answer.body).to eq 'new body'
          end
        end

        context 'with invalid attributes' do
          before do
            patch api_path,
                params: { access_token: access_token.token,
                          answer: { body: '' } },
                headers: headers
          end

          it 'does not change answer' do
            answer.reload

            expect(answer.body).to eq answer.body
          end
    
          it 'returns status 422' do
            expect(response.status).to eq 422
          end
    
          it 'returns error' do
            expect(json['errors']).to_not be_nil
          end
        end
      end
      
      context 'not author' do
        let!(:other_user)      { create(:user) }
        let!(:other_answer)  { create(:answer, user: other_user) }
        let!(:other_api_path)  { "/api/v1/answers/#{other_answer.id}" }
        let!(:other_old_body)  { other_answer.body }

        it 'does not update Answer' do
          patch other_api_path,
                params: { answer: { title: 'new title', body: 'new body' },
                               access_token: access_token.token },
                headers: headers

          expect(other_answer.body).to eq other_old_body
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user: user) }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'api unauthorizable'

    context 'authorized' do
      context 'author' do
        it 'deletes the answer' do
          expect do
            delete api_path, params: { access_token: access_token.token,
              headers: headers }
          end.to change(Answer, :count).by(-1)
        end

        it 'returns 200 status' do
          delete api_path, params: { access_token: access_token.token },
          headers: headers
          expect(response).to be_successful
        end

        it 'returns deleted answer json' do
          delete api_path, params: { access_token: access_token.token },
          headers: headers

          %w[id body created_at updated_at].each do |attr|
            expect(json['answer'][attr]).to eq answer.send(attr).as_json
          end
        end
      end

      context 'not author' do
        let(:other_user) { create(:user) }
        let!(:other_answer) { create(:answer, user: other_user) }
        let(:other_api_path) { "/api/v1/answers/#{other_answer.id}" }
        
        it 'does not deletes answer' do
          expect do
            delete other_api_path, params: { access_token: access_token.token,
              headers: headers }
          end.to_not change(Answer, :count)
        end
      end
    end
  end
end
