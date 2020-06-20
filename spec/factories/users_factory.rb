# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { 'p4ssw0rd' }
    password_confirmation { 'p4ssw0rd' }
    organization
  end
end
