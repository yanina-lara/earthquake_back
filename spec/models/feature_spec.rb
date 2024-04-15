require 'rails_helper'

RSpec.describe Feature, type: :model do
  describe 'validations' do
    let(:feature) { build(:feature) }

    it 'validates presence of external_id' do
      feature.external_id = nil
      expect(feature).not_to be_valid
      expect(feature.errors[:external_id]).to include("can't be blank")
    end

    it 'validates uniqueness of external_id' do
      existing_feature = create(:feature)
      feature.external_id = existing_feature.external_id
      expect(feature).not_to be_valid
      expect(feature.errors[:external_id]).to include("has already been taken")
    end

    it 'validates inclusion of magnitude' do
      feature.magnitude = 15.0
      expect(feature).not_to be_valid
      expect(feature.errors[:magnitude]).to include("is not included in the list")
    end

    it 'validates inclusion of longitude' do
      feature.longitude = 200.0
      expect(feature).not_to be_valid
      expect(feature.errors[:longitude]).to include("is not included in the list")
    end

    it 'validates inclusion of latitude' do
      feature.latitude = 100.0
      expect(feature).not_to be_valid
      expect(feature.errors[:latitude]).to include("is not included in the list")
    end

    it 'validates presence of mag_type' do
      feature.mag_type = nil
      expect(feature).not_to be_valid
      expect(feature.errors[:mag_type]).to include("Mag type can't be blank")
    end

    it 'validates presence of place' do
      feature.place = nil
      expect(feature).not_to be_valid
      expect(feature.errors[:place]).to include("Place can't be blank")
    end

    it 'validates presence of title' do
      feature.title = nil
      expect(feature).not_to be_valid
      expect(feature.errors[:title]).to include("Title can't be blank")
    end

    it 'validates presence of url' do
      feature.url = nil
      expect(feature).not_to be_valid
      expect(feature.errors[:url]).to include("Url can't be blank")
    end

    it 'validates presence of longitude' do
      feature.longitude = nil
      expect(feature).not_to be_valid
      expect(feature.errors[:longitude]).to include("Longitude can't be blank")
    end

    it 'validates presence of latitude' do
      feature.latitude = nil
      expect(feature).not_to be_valid
      expect(feature.errors[:latitude]).to include("Latitude can't be blank")
    end
  end

  describe 'associations' do
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'methods' do
    it 'returns coordinates as an array' do
      feature = Feature.new(longitude: 45.0, latitude: 30.0)
      expect(feature.coordinates).to eq([45.0, 30.0])
    end
  end
end

