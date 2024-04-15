class Feature < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :external_id, presence: true, uniqueness: true
  validates :magnitude, inclusion: { in: -1.0..10.0 }
  validates :longitude, inclusion: { in: -180.0..180.0 }
  validates :latitude, inclusion: { in: -90.0..90.0 }
  validates :mag_type, :place, :title, :url, :longitude, :latitude, presence: { message: "%{attribute} can't be blank" }

  def coordinates
    [longitude, latitude]
  end

  def type
    "feature"
  end
end
