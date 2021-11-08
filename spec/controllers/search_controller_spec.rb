require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  let!(:questions) { create_list(:question, 3) }

  describe 'Get #search', js: true do
    context 'for one resource', sphinx: true do
      let!(:resource) { 'questions' }
      let!(:query) { 'MyString' }

      ThinkingSphinx::Test.run do
        before do
          get :search, params: { query: query, resource: resource }
        end

        it 'assigns the requested resource to @resource' do
          expect(assigns(:resource)).to eq resource
        end

        it 'assigns the requested query to @query' do
          expect(assigns(:query)).to eq query
        end

        it 'assigns the search result to @result' do
          expect(assigns(:result)).to match_array(questions)
        end

        it 'renders search view' do
          expect(response).to render_template :search
        end
      end
    end

    context 'for all', sphinx: true do
      let!(:answer) { create(:answer) }
      let!(:query) { 'MyTextAnswer' }
      let!(:resource) { 'all' }
      let(:service) { double('SearchController') }

      ThinkingSphinx::Test.run do
        it 'assigns the requested resource to @resource' do
          expect(assigns(:resource)).to eq resource
        end

        it 'assigns the requested query to @query' do
          expect(assigns(:query)).to eq query
        end

        it 'renders search view' do
          expect(response).to render_template :search
        end

        it 'global search' do
          allow(service).to receive(:model_klass).with(resource).and_return(ThinkingSphinx)
          expect(model_klass).to receive(:search).with(query)
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
