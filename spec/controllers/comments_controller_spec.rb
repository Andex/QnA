require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'Post #create' do
    context 'Authenticated user is not author of resource' do
      before { login(user) }
      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect do
            (post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js)
          end.to change(Comment, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect do
            (post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js)
          end.to_not change(Comment, :count)
        end
      end
    end

    context 'Unauthorized user' do
      it 'can not create a comment' do
        expect do
          post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
        end.to_not change(Comment, :count)
      end

      it 'redirects to sign in' do
        post :create, params: { comment: attributes_for(:comment), question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end