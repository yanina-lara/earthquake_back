require 'rails_helper'

RSpec.describe Api::FeaturesController, type: :controller do
  describe 'GET #index' do
    let!(:features) { create_list(:feature, 10) }

    context 'when requesting the list of features' do
      before { get :index }

      it 'returns HTTP status code 200 OK' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a paginated list of features' do
        expect(assigns(:features)).to be_present
        expect(assigns(:features)).to be_a(ActiveRecord::Relation)
      end

      it 'returns data in JSON format' do
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end

      it 'returns pagination information in the JSON response' do
        json_response = JSON.parse(response.body)
        expect(json_response['pagination']).to include(
          'current_page' => 1,
          'total' => 10,
          'per_page' => Api::FeaturesController::DEFAULT_PER_PAGE
        )
      end
    end

    context 'when filtering features by mag_type' do
      let(:allowed_mag_types) { ['md', 'ml', 'ms'] }
      let!(:filtered_features) { create_list(:feature, 5, mag_type: allowed_mag_types.sample) }

      before { get :index, params: { filters: { mag_type: allowed_mag_types.join(',') } } }

      it 'returns only features with allowed mag_type' do
        expect(assigns(:features)).to include(*filtered_features)
      end
    end

    context 'when requesting a specific page' do
      let(:page) { 2 }
      let(:per_page) { 3 }

      before { get :index, params: { page: page, per_page: per_page } }

      it 'returns the correct page of features' do
        expect(assigns(:features)).to eq(Feature.paginate(page: page, per_page: per_page))
      end
    end
  end
end
