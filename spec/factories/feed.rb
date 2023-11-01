FactoryBot.define do
  factory :feed do
    sequence(:id)
    url { "http://example.com/feed#{id}" }
  end
end