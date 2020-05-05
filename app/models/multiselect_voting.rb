# frozen_string_literal: true

class MultiselectVoting < Voting
  validates_numericality_of :max_options, only_integer: true, allow_nil: true, greater_than_or_equal_to: 0

  after_save :handle_options

  attr_accessor :options

  def self.model_name
    Voting.model_name
  end

  private

  def handle_options
    all_questions = options.split
    questions_already_present = questions.pluck(:title)
    questions_to_delete = questions_already_present - all_questions
    questions_to_create = all_questions - questions_already_present

    questions_to_create.each do |question|
      q = questions.create!(title: question)
      %w[Yes No].each { |title| q.options.create!(title: title) }
    end

    questions.where(title: questions_to_delete).destroy_all
  end
end
