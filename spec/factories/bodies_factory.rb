FactoryBot.define do
  factory :body do
    name { "MyString" }
    organization { nil }
    default_votes { 1 }
  end
end
