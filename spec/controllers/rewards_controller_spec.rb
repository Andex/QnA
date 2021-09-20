require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let!(:user) { create(:user, :with_rewards) }
  let!(:question) { create(:question, :with_reward) }

  describe 'Get #index' do
    before do
      login(user)
      get :index
    end

    it 'populates an array of all rewards' do
      expect(assigns(:rewards)).to match_array(user.rewards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'Delete #destroy' do
    context 'Authenticated user' do

      context 'and author' do
        before { login(question.user) }
        context 'of the question' do

          it 'deletes question reward' do
            delete :destroy, params: { id: question.reward.id }, format: :js
            expect(question.reward).to eq nil
          end

          it 're-renders template destroy' do
            delete :destroy, params: { id: question.reward }, format: :js
            expect(response).to render_template :destroy
          end
        end
      end

      context 'and not an author' do
        before { login(user) }

        it 'does not delete question reward' do
          delete :destroy, params: { id: question.reward }, format: :js
          expect(question.reward).to eq question.reward
        end

        it 're-renders to show view' do
          delete :destroy, params: { id: question.reward }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'Unauthenticated user' do
      it 'not deletes question links' do
        delete :destroy, params: { id: question.reward }, format: :js
        expect(question.reward).to eq question.reward
      end

      it 'redirects to sign in' do
        delete :destroy, params: { id: question.reward }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
