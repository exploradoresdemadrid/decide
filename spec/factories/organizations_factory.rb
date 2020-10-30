# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    sequence(:name) { |n| "Organization_#{n}" }
    sequence(:admin_email) { |n| "admin@organization-#{n}.com.invalid" }
    admin_password { '12345678' }
  end
end
