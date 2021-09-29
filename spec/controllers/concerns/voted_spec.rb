require 'rails_helper'

shared_examples_for 'voted' do
  let(:user) { create(:user) }
  let(:votable) { create(described_class.controller_name.classify.underscore.to_sym) }

  describe 'Patch #vote_up' do
    context 'Authenticated user is not author of resource' do
      before { login(user) }

      it 'assigns a voting resource to @votable' do
        patch :vote_up, params: { id: votable }, format: :json
        expect(assigns(:votable)).to eq votable
      end

      it 'saves a new vote in db' do
        expect do
          patch :vote_up, params: { id: votable }, format: :json
          votable.reload
        end.to change(votable.votes, :count).by(1)
      end

      it 'responds with json' do
        patch :vote_up, params: { id: votable }, format: :json
        expect(response.content_type).to eq 'application/json; charset=utf-8'
        expect(response.body).to eq "{\"id\":#{votable.id},\"resource\":\"#{votable.class.to_s.underscore}\",\"rating\":#{votable.rating_value}}"
      end
    end

    context 'Authenticated user is author of resource' do
      before { login(votable.user) }
      it 'does not saves a new vote in db' do
        expect do
          patch :vote_up, params: { id: votable }, format: :json
          votable.reload
        end.to change(votable.votes, :count).by(0)
      end

      it 'responds with json' do
        patch :vote_up, params: { id: votable }, format: :json
        expect(response.content_type).to eq nil
        expect(response.body).to eq ""
      end
    end

    context 'Unauthenticated user' do
      it 'message to sign in' do
        patch :vote_up, params: { id: votable }, format: :json
        expect(response.content_type).to eq 'application/json; charset=utf-8'
        expect(response.body).to eq "{\"error\":\"You need to sign in or sign up before continuing.\"}"
      end
    end
  end

  describe 'Patch #vote_down' do
    context 'Authenticated user is not author of resource' do
      before { login(user) }

      it 'assigns a voting resource to @votable' do
        patch :vote_down, params: { id: votable }, format: :json
        expect(assigns(:votable)).to eq votable
      end

      it 'saves a new vote in db' do
        expect do
          patch :vote_down, params: { id: votable }, format: :json
          votable.reload
        end.to change(votable.votes, :count).by(1)
      end

      it 'responds with json' do
        patch :vote_down, params: { id: votable }, format: :json
        expect(response.content_type).to eq 'application/json; charset=utf-8'
        expect(response.body).to eq "{\"id\":#{votable.id},\"resource\":\"#{votable.class.to_s.underscore}\",\"rating\":#{votable.rating_value}}"
      end
    end

    context 'Authenticated user is author of resource' do
      before { login(votable.user) }
      it 'does not saves a new vote in db' do
        expect do
          patch :vote_down, params: { id: votable }, format: :json
          votable.reload
        end.to change(votable.votes, :count).by(0)
      end

      it 'responds with json' do
        patch :vote_down, params: { id: votable }, format: :json
        expect(response.content_type).to eq nil
        expect(response.body).to eq ""
      end
    end

    context 'Unauthenticated user' do
      it 'message to sign in' do
        patch :vote_down, params: { id: votable }, format: :json
        expect(response.content_type).to eq 'application/json; charset=utf-8'
        expect(response.body).to eq "{\"error\":\"You need to sign in or sign up before continuing.\"}"
      end
    end
  end

  describe 'Delete #cancel_vote' do
    let!(:vote) { create(:vote, votable: votable, user: user) }

    context 'Authenticated user is not author of resource' do
      before { login(user) }

      it 'assigns a voting resource' do
        delete :cancel_vote, params: { id: votable }, format: :json
        expect(assigns(:votable)).to eq votable
      end

      it 'deletes the vote' do
        expect{ (delete :cancel_vote, params: { id: votable }, format: :json) }.to change(votable.votes, :count).by(-1)
      end

      it 'responds with json' do
        delete :cancel_vote, params: { id: votable }, format: :json
        expect(response.content_type).to eq 'application/json; charset=utf-8'
        expect(response.body).to eq "{\"id\":#{votable.id},\"resource\":\"#{votable.class.to_s.underscore}\",\"rating\":#{votable.rating_value}}"
      end
    end

    context 'Authenticated user is author of resource' do
      before { login(votable.user) }

      it 'does not deletes the votable' do
        expect do
          (delete :cancel_vote, params: { id: votable }, format: :json) end.to_not change(votable.votes, :count)
      end

      it 'responds with json' do
        delete :cancel_vote, params: { id: votable }, format: :json
        expect(response.content_type).to eq nil
        expect(response.body).to eq ""
      end
    end

    context 'Unauthenticated user' do
      it 'does not deletes the votable' do
        expect { delete :cancel_vote, params: { id: votable }, format: :json }.to_not change(votable.votes, :count)
      end

      it 'responds with json' do
        delete :cancel_vote, params: { id: votable }, format: :json
        expect(response.content_type).to eq "application/json; charset=utf-8"
        expect(response.body).to eq "{\"error\":\"You need to sign in or sign up before continuing.\"}"
      end
    end
  end
end
