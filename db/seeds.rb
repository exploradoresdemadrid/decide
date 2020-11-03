# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless Rails.env.development?
  raise 'Running seeds in non-development environment'
end

Voting.destroy_all
Group.destroy_all
User.destroy_all
Organization.destroy_all

edm_org = Organization.find_or_create_by(name: 'Exploradores de Madrid')
sample_org = Organization.find_or_create_by(name: 'Sample organization')
Body.update_all(default_votes: 5)

[[edm_org, 'edm'], [sample_org, 'sample']]. each do |(org, org_name)|
  %i[admin superadmin].each do |role|
    User.find_or_create_by!(organization: org, email: "#{role}_#{org_name}@example.com") do |user|
      user.password = '12345678'
      user.role = role
      user.organization = org
    end
  end

  max_votes = 6

  groups = [
    ['Group 1', 1],
    ['Group 2', 2],
    ['Group 3', 3]
  ].map do |(name, number)|
    Group.find_or_create_by!(organization: org, number: number) do |group|
      group.name = "#{name.downcase.capitalize} #{org.name}"
      group.email = "group-#{number}@#{org.name.downcase.gsub(' ', '')}.com.invalid"
      group.available_votes = 1
    end.tap{ |g| g.assign_votes_to_body_by_name(org.name, 1 + rand(max_votes - 1)) }
  end

  public_voting = Voting.find_or_create_by!(organization: org, title: "#{org.name} - Weather voting") do |voting|
    voting.description = 'This is not a secret voting'
    voting.secret = false
  end

  public_voting.open!

  public_voting.questions.find_or_create_by!(title: 'What color is the sky?') do |question|
    question.options.find_or_initialize_by(title: 'Blue')
    question.options.find_or_initialize_by(title: 'Red')
    question.options.find_or_initialize_by(title: 'Green')
  end

  public_voting.questions.find_or_create_by!(title: 'How is the temperature?') do |question|
    question.options.find_or_initialize_by(title: 'Freezing cold')
    question.options.find_or_initialize_by(title: 'Not bad')
    question.options.find_or_initialize_by(title: 'Really hot')
    question.options.find_or_initialize_by(title: 'Are we in hell?')
  end

  groups.each do |group|
    response = public_voting.questions.map do |question|
      [
        question.id,
        group.votes_in_body(question.body).times.map { question.option_ids.sample }.group_by(&:itself).transform_values(&:count)
      ]
    end.to_h

    VoteSubmissionService.new(group, public_voting, response).vote!
    puts "[GS #{group.id}] Vote submitted"
  end

  public_voting.finished!
end
