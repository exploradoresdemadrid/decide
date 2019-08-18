# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'groups/edit', type: :view do
  before(:each) do
    @group = assign(:group, create(:group))
  end

  it 'renders the edit group form' do
    render

    assert_select 'form[action=?][method=?]', group_path(@group), 'post' do
      assert_select 'input[name=?]', 'group[name]'
      assert_select 'input[name=?]', 'group[number]'
      assert_select 'input[name=?]', 'group[available_votes]'
    end
  end
end
