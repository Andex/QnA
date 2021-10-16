require 'rails_helper'
require Rails.root.join('spec/controllers/concerns/voted_spec.rb')

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'Post #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect do
            (post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js)
          end.to change(question.answers, :count).by(1)
        end

        it 'redirects to create view' do
          post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect do
            (post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js)
          end.to_not change(Answer, :count)
        end

        it 're-renders create view' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'Unauthenticated user' do
      it 'redirects to sign in' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end


  describe 'Delete #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'and author' do
        let!(:answer) { create(:answer, question: question, user: user) }

        it 'deletes the answer' do
          expect{ (delete :destroy, params: { id: answer }, format: :js) }.to change(Answer, :count).by(-1)
        end

        it 'redirects to index view' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'and not an author' do
        let!(:answer) { create(:answer, question: question) }

        it 'does not delete the answer' do
          expect { (delete :destroy, params: { id: answer }, format: :js) }.to_not change(Answer, :count)
        end

        it 're-renders to show view' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template nil
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:answer) { create(:answer) }

      it 'not deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to sign in' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end


  describe 'Patch #update' do
    let(:answer) { create(:answer, question: question) }

    context 'Authenticated user is author' do
      before { login(answer.user) }

      context 'with valid attributes' do
        before { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }

        it 'changes answer attributes' do
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not update the answer' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'Authenticated user is not author' do
      before { login(user) }

      it 'does not update the answer' do
        expect do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        end.to_not change(answer, :body)
      end

      it 're-renders to update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template nil
      end
    end

    context 'Unauthenticated user' do
      it 'redirects to sign in' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'Patch #best' do
    let(:answer) { create(:answer, question: question) }

    context 'Authenticated user is author of question' do
      before { login(answer.question.user) }

      it 'saves answer as the best in db' do
        patch :best, params: { id: answer }, format: :js

        answer.question.reload
        expect(question.best_answer).to eq answer
      end

      it 'renders best view' do
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end

    context 'Authenticated user is not author of question' do
      it 'does not saves answer as the best in db' do
        login(user)
        expect{ (patch :best, params: { id: answer }, format: :js) }.to_not change(answer.question, :best_answer_id)
      end
    end

    context 'Unauthenticated user' do
      it 'redirects to sign in' do
        patch :best, params: { id: answer, question: answer.question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  it_behaves_like 'voted'
end
