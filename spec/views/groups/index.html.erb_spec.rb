# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'groups/index', type: :view do
  before(:each) do
    assign(:groups, create_list(:group, 2))
  end

  it 'renders a list of groups' do
    render
    assert_select 'tr>td', text: /Group_\d+/, count: 2
  end
end
