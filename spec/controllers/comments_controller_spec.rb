require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'Post #create' do
    context 'Authenticated user' do
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

  describe 'Delete #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'and author' do
        context 'of the comment on the question' do
          let!(:comment) { create(:comment, commentable: question, user: user) }

          it 'deletes comment' do
            expect do
              (delete :destroy, params: { id: comment.id }, format: :js)
            end.to change(question.comments, :count).by(-1)
          end

          it 're-renders template destroy' do
            delete :destroy, params: { id: comment.id }, format: :js
            expect(response).to render_template :destroy
          end
        end

        context 'of the comment on the answer' do
          let!(:answer) { create(:answer, question: question) }
          let!(:comment) { create(:comment, commentable: answer, user: user) }

          it 'deletes comment' do
            expect do
              (delete :destroy, params: { id: comment.id }, format: :js)
            end.to change(answer.comments, :count).by(-1)
          end

          it 're-renders template destroy' do
            delete :destroy, params: { id: comment.id }, format: :js
            expect(response).to render_template :destroy
          end
        end
      end

      context 'and not an author' do
        let!(:comment_question) { create(:comment, commentable: question) }
        let!(:answer) { create(:answer, question: question) }
        let!(:comment_answer) { create(:comment, commentable: answer) }

        it 'does not delete the comment on the question' do
          expect do
            (delete :destroy, params: { id: comment_question.id }, format: :js)
          end.to_not change(question.comments, :count)
        end

        it 'returns http status forbidden' do
          delete :destroy, params: { id: comment_question.id }, format: :js
          expect(response).to render_template :destroy
        end

        it 'does not delete the comment on the answer' do
          expect do
            (delete :destroy, params: { id: comment_answer.id }, format: :js)
          end.to_not change(answer.comments, :count)
        end

        it 'returns http status forbidden' do
          delete :destroy, params: { id: comment_answer.id }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:comment_question) { create(:comment, commentable: question) }
      let!(:answer) { create(:answer, question: question) }
      let!(:comment_answer) { create(:comment, commentable: answer) }

      it 'not deletes the comment on the question' do
        expect do
          delete :destroy, params: { id: comment_question.id }, format: :js
        end.to_not change(question.comments, :count)
      end

      it 'redirects to sign in' do
        delete :destroy, params: { id: comment_question.id }
        expect(response).to redirect_to new_user_session_path
      end

      it 'not deletes the comment on the answer' do
        expect { delete :destroy, params: { id: comment_answer.id }, format: :js }.to_not change(answer.comments, :count)
      end

      it 'redirects to sign in' do
        delete :destroy, params: { id: comment_answer.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
