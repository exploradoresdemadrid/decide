require 'rails_helper'

RSpec.describe "votings/new", type: :view do
  before(:each) do
    assign(:voting, Voting.new(
      :title => "MyString",
      :description => "MyString",
      :status => 1
    ))
  end

  it "renders new voting form" do
    render

    assert_select "form[action=?][method=?]", votings_path, "post" do

      assert_select "input[name=?]", "voting[title]"

      assert_select "input[name=?]", "voting[description]"

      assert_select "input[name=?]", "voting[status]"
    end
  end
end
