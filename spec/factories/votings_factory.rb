# frozen_string_literal: true

FactoryBot.define do
  factory :voting do
    sequence(:title) { |n| "Title of voting #{n}" }
    sequence(:description) { |n| "Description of voting #{n}" }
    status { :open }

    trait(:invalid) { title { nil } }

    factory :multiselect_voting, class: 'MultiselectVoting' do
      max_options { 5 }
    end
  end
end
