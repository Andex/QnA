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

        expect(page).to have_content result
      end
    end
  end

  scenario 'search from questions', sphinx: true do
    it_behaves_like 'searchable' do
      given!(:query) { 'My' }
      given!(:resource_name) { 'questions' }
      given!(:result) { query.exactly(6).times }
    end
  end

  scenario 'search from answers', sphinx: true do
    given(:query) { 'MyText' }
    given(:resource_name) { 'answers' }
    given(:result) { query.exactly(3).times }
  end

  scenario 'search from users', sphinx: true do
    given!(:query) { 'user' }
    given!(:resource_name) { 'users' }
    given!(:result) { query.exactly(3).times }
  end

  scenario 'search from comments', sphinx: true do
    given!(:query) { 'MyComment' }
    given!(:resource_name) { 'comments' }
    given!(:result) { query.exactly(3).times }
  end

  scenario 'search from all', sphinx: true do
    given!(:query) { 'My' }
    given!(:resource_name) { 'all' }
    given!(:result) { query.exactly(12).times }
  end
end
