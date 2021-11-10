require 'sphinx_helper'

feature 'User can find information on search', "
  In order to find needed info
  As un user
  I'd like to be able to search for a word or phrase throughout the site
" do
  given!(:questions) { create_list(:question, 3, :with_best_answer, :with_comments) }

  shared_examples_for 'searchable' do
    scenario 'fill form and send result' do
      visit questions_path

      ThinkingSphinx::Test.run do
        fill_in 'query', with: query
        select resource_name, from: 'resource'

        click_on 'Search'

        expect(page).to have_content(query)
      end
    end
  end

  context 'search from questions', sphinx: true do
    it_behaves_like 'searchable' do
      given!(:query) { 'My String' }
      given!(:resource_name) { 'questions' }
    end
  end

  context 'search from answers', sphinx: true do
    it_behaves_like 'searchable' do
      given(:query) { 'Answer' }
      given(:resource_name) { 'answers' }
    end
  end

  context 'search from users', sphinx: true do
    it_behaves_like 'searchable' do
      given!(:query) { 'test' }
      given!(:resource_name) { 'users' }
    end
  end

  context 'search from comments', sphinx: true do
    it_behaves_like 'searchable' do
      given!(:query) { 'Comment' }
      given!(:resource_name) { 'comments' }
    end
  end

  context 'search from all', sphinx: true do
    it_behaves_like 'searchable' do
      given!(:query) { 'My' }
      given!(:resource_name) { 'all' }
    end
  end
end
