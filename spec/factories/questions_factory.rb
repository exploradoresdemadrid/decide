FactoryBot.define do
  factory :question do
    voting { nil }
    title { "MyString" }
    description { "MyText" }
  end
end
