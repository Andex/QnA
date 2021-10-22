require 'rails_helper'

feature 'User can change question rating by voting', "
  In order to vote up or down a question
  As un authenticated user
  I'd like to be able vote up or down a question
" do
  it_behaves_like 'voting' do
    given(:question) { create(:question) }

    given(:author) { question.user }
    given(:other_user) { create(:user) }
    given(:resource_voting_page) { question }
    given(:resource_rating_class) { '.question .rating' }
  end
end
