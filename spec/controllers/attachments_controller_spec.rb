require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:user) { create(:user) }

  describe 'Delete #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'and author' do
        let!(:question) { create(:question, :with_files, user: user) }

        it 'deletes question files' do
          expect{ (delete :destroy, params: { id: question.files.first.id }, format: :js) }.to change(question.files, :count).by(-1)
        end

        it 're-renders template destroy' do
          delete :destroy, params: { id: question.files.first.id }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'and not an author' do
        let!(:question) { create(:question, :with_files) }

        it 'does not delete question files' do
          expect { (delete :destroy, params: { id: question.files.first.id }, format: :js) }.to_not change(question.files, :count)
        end

        it 're-renders to show view' do
          delete :destroy, params: { id: question.files.first.id }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:question) { create(:question, :with_files) }

      it 'not deletes question files' do
        expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.to_not change(question.files, :count)
      end

      it 'redirects to sign in' do
        delete :destroy, params: { id: question.files.first.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
