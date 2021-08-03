require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'Get #index' do
    before { get :index }
    let(:questions) { create_list(:question, 3) }
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'Get #show' do
    before { get :show, params: { id: question } }
    let(:question) { create(:question) }
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'Get #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'Get #edit' do
    let(:question) { create(:question) }
    before { get :edit, params: { id: question } }
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'Post #create' do
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        count = Question.count

        post :create, params: { question: { title: '123', body: '123' } }
        expect(Question.count).to eq count + 1
      end
      it 'redirects to show view' do
        post :create, params: { question: { title: '123', body: '123' } }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question'
      it 're-renders new view'
    end
  end
end