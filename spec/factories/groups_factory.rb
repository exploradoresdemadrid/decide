# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "Group_#{n}" }
    sequence(:number) { |n| n }
    available_votes { 1 }
    organization

    trait(:invalid) { name { nil } }
  end
end
