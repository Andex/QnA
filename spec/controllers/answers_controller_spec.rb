require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'Post #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect do
   (post :create,
         params: { answer: attributes_for(:answer), question_id: question }) end.to change(question.answers, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { answer: attributes_for(:answer), question_id: question }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect do
   (post :create,
         params: { answer: attributes_for(:answer, :invalid), question_id: question }) end.to_not change(Answer, :count)
        end

        it 're-renders show view' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
          expect(response).to render_template 'questions/show'
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

  describe 'Get #show' do
    let(:answer) { create(:answer) }

    it 'renders show view' do
      get :show, params: { id: answer, question_id: question }
      expect(response).to render_template :show
    end
  end

  describe 'Delete #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'and author' do
        let!(:answer) { create(:answer, question: question, user: user) }

        it 'deletes the answer' do
          expect{ (delete :destroy, params: { id: answer }) }.to change(Answer, :count).by(-1)
        end

        it 'redirects to index view' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'and not an author' do
        let!(:answer) { create(:answer, question: question) }

        it 'does not delete the answer' do
          expect { (delete :destroy, params: { id: answer }) }.to_not change(Answer, :count)
        end

        it 're-renders to show view' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
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
end
