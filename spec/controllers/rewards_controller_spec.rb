require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let!(:user_with_rewards) { create(:user, :with_rewards) }
  let!(:question_with_reward) { create(:question, :with_reward) }

  describe 'Get #index' do
    before do
      login(user_with_rewards)
      get :index
    end

    it 'populates an array of all rewards' do
      expect(assigns(:rewards)).to match_array(user_with_rewards.rewards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'Delete #destroy' do
    context 'Authenticated user' do

      context 'and author' do
        before { login(question_with_reward.user) }
        context 'of the question' do

          it 'deletes question reward' do
            delete :destroy, params: { id: question_with_reward.reward.id }, format: :js
            question_with_reward.reload
            expect(question_with_reward.reward).to eq nil
          end

          it 're-renders template destroy' do
            delete :destroy, params: { id: question_with_reward.reward }, format: :js
            expect(response).to render_template :destroy
          end
        end
      end

      context 'and not an author' do
        before { login(user_with_rewards) }

        it 'does not delete question reward' do
          delete :destroy, params: { id: question_with_reward.reward }, format: :js
          question_with_reward.reload
          expect(question_with_reward.reward).to eq question_with_reward.reward
        end

        it 're-renders to show view' do
          delete :destroy, params: { id: question_with_reward.reward }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'Unauthenticated user' do
      it 'not deletes question links' do
        delete :destroy, params: { id: question_with_reward.reward }, format: :js
        question_with_reward.reload
        expect(question_with_reward.reward).to eq question_with_reward.reward
      end

      it 'redirects to sign in' do
        delete :destroy, params: { id: question_with_reward.reward }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
