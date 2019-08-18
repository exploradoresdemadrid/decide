# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'groups/show', type: :view do
  before(:each) do
    @group = assign(:group, create(:group))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to include(@group.name)
    expect(rendered).to include(@group.number.to_s)
    expect(rendered).to include(@group.available_votes.to_s)
  end
end
