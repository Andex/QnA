require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  let!(:questions) { create_list(:question, 3) }
  
  describe 'Get #search', js: true do
    context 'for one resource', sphinx: true do
      let!(:resource) { 'questions' }
      let!(:query) { 'MyString' }

      ThinkingSphinx::Test.run do
        it 'assigns the requested resource to @resource' do
          get :search, params: { query: query, resource: resource }
          expect(assigns(:resource)).to eq resource
        end

        it 'assigns the requested query to @query' do
          get :search, params: { query: query, resource: resource }
          expect(assigns(:query)).to eq query
        end

        it 'assigns the search result to @result' do
          allow(resource.classify.constantize).to receive(:search).with(query).and_return(questions)
          get :search, params: { query: query, resource: resource }

          expect(assigns(:result)).to match_array(questions)
        end

        it 'renders search view' do
          get :search, params: { query: query, resource: resource }
          expect(response).to render_template :search
        end
      end
    end

    context 'for all', sphinx: true do
      let!(:answer) { create(:answer) }
      let!(:query) { 'MyTextAnswer' }
      let!(:resource) { 'all' }

      ThinkingSphinx::Test.run do
        it 'assigns the requested resource to @resource' do
          get :search, params: { query: query, resource: resource }
          expect(assigns(:resource)).to eq resource
        end

        it 'assigns the requested query to @query' do
          get :search, params: { query: query, resource: resource }
          expect(assigns(:query)).to eq query
        end

        it 'renders search view' do
          get :search, params: { query: query, resource: resource }
          expect(response).to render_template :search
        end

        it 'global search' do
          allow(ThinkingSphinx).to receive(:search).with(query)
          get :search, params: { query: query, resource: resource }
        end

        it 'global search and returns answer' do
          expect(ThinkingSphinx).to receive(:search).with(query).and_return(answer)
          get :search, params: { query: query, resource: resource }
        end
      end
    end
  end
end
