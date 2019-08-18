# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'groups/new', type: :view do
  before(:each) do
    assign(:group, build(:group))
  end

  it 'renders new group form' do
    render

    assert_select 'form[action=?][method=?]', groups_path, 'post' do
      assert_select 'input[name=?]', 'group[name]'
      assert_select 'input[name=?]', 'group[number]'
      assert_select 'input[name=?]', 'group[available_votes]'
    end
  end
end
