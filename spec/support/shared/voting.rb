shared_examples 'voting' do
  describe 'Unauthenticated user' do
    scenario "can't to change resource rating by voting" do
      visit question_path(resource_voting_page)

      expect(page).to_not have_link 'Cancel vote'
      expect(page).to_not have_link 'UP'
      expect(page).to_not have_link 'DOWN'
    end
  end

  describe 'Authenticated author' do
    scenario 'tries to change resource rating by voting' do
      login(author)
      visit question_path(resource_voting_page)

      within resource_rating_class do
        expect(page).to_not have_link 'Cancel vote'
        expect(page).to_not have_link 'UP'
        expect(page).to_not have_link 'DOWN'
      end
    end
  end

  describe 'Authenticated user', js: true do
    before do
      login(other_user)
      visit question_path(resource_voting_page)
    end

    scenario 'votes up a resource' do
      within resource_rating_class do
        click_on 'UP'

        expect(page).to have_content '1'
        expect(page).to have_link 'Cancel vote'
        expect(page).to_not have_link 'UP'
        expect(page).to_not have_link 'DOWN'
      end
    end

    scenario 'votes down a resource' do
      within resource_rating_class do
        click_on 'DOWN'

        expect(page).to have_content '-1'
        expect(page).to have_link 'Cancel vote'
        expect(page).to_not have_link 'UP'
        expect(page).to_not have_link 'DOWN'
      end
    end

    scenario 'cancels vote a resource' do
      within resource_rating_class do
        click_on 'UP'

        expect(page).to_not have_link 'UP'
        expect(page).to_not have_link 'DOWN'

        click_on 'Cancel vote'

        expect(page).to have_content '0'
        expect(page).to_not have_link 'Cancel vote'
        expect(page).to have_link 'UP'
        expect(page).to have_link 'DOWN'
      end
    end
  end
end
