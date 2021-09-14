require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'Get #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'Get #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns the requested answer to @new_answer' do
      expect(assigns(:new_answer)).to be_a_new(Answer)
    end

    it 'assigns a new Link to @answer.links' do
      expect(assigns(:new_answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'Get #new' do
    context 'Authenticated user' do
      before { login(user) }

      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'assigns a new Link to @question.links' do
        expect(assigns(:question).links.first).to be_a_new(Link)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'Unauthenticated user' do
      it 'redirects to sign in' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'Get #edit' do
    context 'Authenticated user' do
      before { login(user) }

      before { get :edit, params: { id: question } }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'Unauthenticated user' do
      it 'redirects to sign in' do
        get :edit, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'Post #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect{ (post :create, params: { question: attributes_for(:question) }) }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect do
            (post :create, params: { question: attributes_for(:question, :invalid) }) end.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'Unauthenticated user' do
      context 'with valid attributes' do
        it 'not saves a new question in the database' do
          expect{ (post :create, params: { question: attributes_for(:question) }) }.not_to change(Question, :count)
        end

        it 'redirects to sign in' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to new_user_session_path
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect do
            (post :create, params: { question: attributes_for(:question, :invalid) }) end.to_not change(Question, :count)
        end

        it 'redirects to sign in' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'Patch #update' do
    context 'Authenticated user is author' do
      before { login(question.user) }

      context 'with valid attributes' do
        it 'assigned the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        before { patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js}

        it 'changes question attributes' do
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'render update view' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

        it 'does not change question' do
          question.reload

          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end

        it 're-renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'Authenticated user is not author' do
      before { login(user) }

      it 'does not update the question' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        end.to_not change(question, :body)
      end

      it 're-renders to update view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Unauthenticated user' do
      it 'redirects to sign in' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'Delete #destroy' do
    let!(:question) { create(:question) }

    context 'Authenticated user' do
      context 'and author' do
        before { login(question.user) }

        it 'deletes the question' do
          expect{ (delete :destroy, params: { id: question }) }.to change(Question, :count).by(-1)
        end

        it 'redirects to index view' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'and not an author' do
        before { login(user) }

        it 'does not deletes the question' do
          expect do
            (delete :destroy, params: { id: question }) end.to_not change(Question, :count)
        end

        it 're-renders to show view' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to :question
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to sign in' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
