require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'Post #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'not subscribed to the question yet' do
        it 'assigns a question subscription to the current user' do
          post :create, params: { question_id: question }, format: :js
          expect(assigns(:subscription).user).to eq user
        end

        it 'saves a new subscription for user in the database' do
          expect{post :create, params: { question_id: question }, format: :js}.to change(user.subscriptions, :count).by(1)
        end
      end

      context 'already subscribed to the question' do
        it 'does not save the subscription' do
          question.subscriptions.create(user: user)
          expect{ post :create, params: { question_id: question }, format: :js }.to_not change(Subscription, :count)
        end
      end
    end

    context 'Unauthorized user' do
      it 'can not create a subscription' do
        expect{ post :create, params: { question_id: question }, format: :js }.to_not change(user.subscriptions, :count)
      end###

      it 'redirects to sign in' do
        post :create, params: { question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'Delete #destroy' do
    let!(:subscription) { create(:subscription, question: question, user: user) }

    context 'Authenticated user' do
      context 'already subscribed to the question' do
        it 'deletes the subscription for user in the database' do
          login(user)
          expect{ delete :destroy, params: { id: subscription }, format: :js }.to_not change(Subscription, :count)
        end
      end

      context 'not subscribed to the question yet' do
        it 'does not delete the subscription for user in the database' do
          login(create(:user))
          expect{ delete :destroy, params: { id: subscription }, format: :js }.to_not change(user.subscriptions, :count)
        end
      end
    end

    context 'Unauthorized user' do
      it 'can not delete a subscription' do
        expect{ delete :destroy, params: { id: subscription }, format: :js }.to_not change(user.subscriptions, :count)
      end

      it 'redirects to sign in' do
        delete :destroy, params: { id: subscription }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
