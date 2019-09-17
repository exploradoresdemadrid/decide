require 'rails_helper'

RSpec.describe "votings/edit", type: :view do
  before(:each) do
    @voting = assign(:voting, Voting.create!(
      :title => "MyString",
      :description => "MyString",
      :status => 1
    ))
  end

  it "renders the edit voting form" do
    render

    assert_select "form[action=?][method=?]", voting_path(@voting), "post" do

      assert_select "input[name=?]", "voting[title]"

      assert_select "input[name=?]", "voting[description]"

      assert_select "input[name=?]", "voting[status]"
    end
  end
end
