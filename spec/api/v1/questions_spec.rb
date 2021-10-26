require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json"  } }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /api/v1/questions' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'api unauthorizable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'api authorizable'

      it_behaves_like 'Checkable public fields' do
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
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'api unauthorizable'

    context 'authorized' do
      let(:resource) { question }
      let(:resource_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'api authorizable'

      it_behaves_like 'Checkable public fields' do
        let(:public_fields) { %w[id title body created_at updated_at] }
      end

      it_behaves_like 'Checkable contains object' do
        let(:objects) { %w[user reward] }
      end

      it_behaves_like 'Checkable size of resource list' do
        let(:resource_contents) { %w[comments files links] }
      end

      context 'question links' do
        it_behaves_like 'Checkable public fields' do
          let(:resource) { question.links.first }
          let(:resource_response) { json['question']['links'].first }
          let(:public_fields) { %w[id name url created_at updated_at] }
        end
      end

      context 'question comments' do
        it_behaves_like 'Checkable public fields' do
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

  describe 'POST /api/v1/questions' do
    let(:method) { :post }
    let(:api_path) { '/api/v1/questions' }
    
    it_behaves_like 'api unauthorizable'

    context 'authorized' do
      context 'with valid attributes' do
        let(:question) { attributes_for(:question) }
        let(:question_response) { json['question'] }
        let(:resource) { question }
        let(:resource_response) { question_response }

        it 'creates a new Question' do
          expect{ post api_path, params: { access_token: access_token.token, question: question },
          headers: headers }.to change(Question, :count).by(1)
        end

        before do
          post api_path,
               params: { access_token: access_token.token, question: question },
               headers: headers
        end

        it_behaves_like 'api authorizable'
    
        it 'contains user object' do
          expect(question_response['user']['id']).to eq access_token.resource_owner_id
        end
  
        it 'creates a question with the correct attributes' do
           expect(Question.last).to have_attributes question
        end
      end
    
      context 'with invalid attributes' do
        let(:question) { attributes_for(:question, :invalid) }
    
        it "doesn't save question, renders errors" do
          expect { post api_path, params: { access_token: access_token.token, question: question },
          headers: headers }.to_not change(Question, :count)
        end

        before do
          post api_path,
               params: { access_token: access_token.token, question: question },
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

  describe 'PATCH /api/v1/questions/:id' do
    let!(:question) { create(:question, :with_reward, :with_files, :with_links, :with_comments, user: user) }
    let(:method) { :patch }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'api unauthorizable'

    context 'authorized' do
      context 'author' do
        context 'with valid attributes' do
          let(:question_response) { json['question'] }

          before do
            patch api_path,
                params: { access_token: access_token.token,
                          question: { title: 'new title', body: 'new body' } },
                headers: headers
          end

          it_behaves_like 'api authorizable'

          it 'contains user object' do
            expect(question_response['user']['id']).to eq access_token.resource_owner_id
          end

          it 'changes question attributes' do
            question.reload

            expect(question.title).to eq 'new title'
            expect(question.body).to eq 'new body'
          end
        end

        context 'with invalid attributes' do
          before do
            patch api_path,
                params: { access_token: access_token.token,
                          question: { title: '', body: '' } },
                headers: headers
          end

          it 'does not change question' do
            question.reload

            expect(question.title).to eq question.title
            expect(question.body).to eq question.body
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
        let!(:other_question)  { create(:question, user: other_user) }
        let!(:other_api_path)  { "/api/v1/questions/#{other_question.id}" }
        let!(:other_old_title) { other_question.title }
        let!(:other_old_body)  { other_question.body }

        it 'does not update Question' do
          patch other_api_path,
                params: { question: { title: 'new title', body: 'new body' },
                               access_token: access_token.token },
                headers: headers

          expect(other_question.title).to eq other_old_title
          expect(other_question.body).to eq other_old_body
        end
      end
    end
  end
end
