FactoryGirl.define do
  factory :commit do
    author 'jhon'

    trait :processed do
      processed_at Time.now.midday
    end
  end
end
