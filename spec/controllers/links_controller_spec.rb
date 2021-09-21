require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user) { create(:user) }

  describe 'Delete #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'and author' do
        context 'of the question' do
          let!(:question) { create(:question, :with_links, user: user) }

          it 'deletes question links' do
            expect do
              (delete :destroy, params: { id: question.links.first.id }, format: :js) end.to change(question.links, :count).by(-1)
          end

          it 're-renders template destroy' do
            delete :destroy, params: { id: question.links.first.id }, format: :js
            expect(response).to render_template :destroy
          end
        end

        context 'of the answer' do
          let!(:question) { create(:question) }
          let!(:answer) { create(:answer, :with_links, user: user) }

          it 'deletes question links' do
            expect do
              (delete :destroy, params: { id: answer.links.first.id }, format: :js) end.to change(answer.links, :count).by(-1)
          end

          it 're-renders template destroy' do
            delete :destroy, params: { id: answer.links.first.id }, format: :js
            expect(response).to render_template :destroy
          end
        end
      end

      context 'and not an author' do
        let!(:question) { create(:question, :with_links) }
        let!(:answer) { create(:answer, :with_links) }

        it 'does not delete question links' do
          expect do
            (delete :destroy, params: { id: question.links.first.id }, format: :js) end.to_not change(question.links, :count)
        end

        it 're-renders to show view' do
          delete :destroy, params: { id: question.links.first.id }, format: :js
          expect(response).to render_template :destroy
        end

        it 'does not delete answer links' do
          expect do
            (delete :destroy, params: { id: answer.links.first.id }, format: :js) end.to_not change(answer.links, :count)
        end

        it 're-renders to show view' do
          delete :destroy, params: { id: answer.links.first.id }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:question) { create(:question, :with_links) }
      let!(:answer) { create(:answer, :with_links) }

      it 'not deletes question links' do
        expect do
          delete :destroy, params: { id: question.links.first.id }, format: :js end.to_not change(question.links, :count)
      end

      it 'redirects to sign in' do
        delete :destroy, params: { id: question.links.first.id }
        expect(response).to redirect_to new_user_session_path
      end

      it 'not deletes answer links' do
        expect { delete :destroy, params: { id: answer.links.first.id }, format: :js }.to_not change(answer.links, :count)
      end

      it 'redirects to sign in' do
        delete :destroy, params: { id: answer.links.first.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
