FactoryBot.define do
  factory :feature do
    magnitude { rand(0.1..9.9).round(2) }
    place { ['City A', 'City B', 'City C'].sample }
    time { Time.now - rand(1..30).days }
    mag_type { %w[md ml ms mw me mi mb mlg].sample }
    title { "Title #{rand(1..100)}" }
    longitude { rand(-180.0..180.0) }
    latitude { rand(-90.0..90.0) }
    external_id { SecureRandom.hex(10) }
    url { "https://example.com/#{SecureRandom.hex(8)}" }
  end
end
