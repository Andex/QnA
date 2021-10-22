require 'rails_helper'

feature 'User can change answer rating by voting', "
  In order to vote up or down a answer
  As un authenticated user
  I'd like to be able vote up or down a answer
" do
  it_behaves_like 'voting' do
    given(:question) { create(:question) }
    given(:answer) { create(:answer, question: question) }

    given(:author) { answer.user }
    given(:other_user) { question.user }
    given(:resource_voting_page) { answer.question }
    given(:resource_rating_class) { ".answer-id-#{answer.id} .rating" }
  end
end
