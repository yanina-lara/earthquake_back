require 'rails_helper'

RSpec.describe Api::CommentsController, type: :controller do
  let(:feature) { FactoryBot.create(:feature) }

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new comment' do
        expect {
          post :create, params: { feature_id: feature.external_id, body: 'This is a comment' }
        }.to change(Comment, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it 'returns the created comment' do
        post :create, params: { feature_id: feature.external_id, body: 'This is a comment' }
        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response['body']).to eq('This is a comment')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new comment' do
        expect(Feature.exists?(feature.id)).to be true

        expect {
          post :create, params: { feature_id: feature.external_id, body: '' }
        }.not_to change(Comment, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors' do
        expect(Feature.exists?(feature.id)).to be true

        post :create, params: { feature_id: feature.external_id, body: '' }
        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Body can't be blank")
      end
    end
  end
end
