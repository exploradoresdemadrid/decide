require 'rails_helper'

RSpec.describe "votings/index", type: :view do
  before(:each) do
    assign(:votings, [
      Voting.create!(
        :title => "Title",
        :description => "Description",
        :status => 2
      ),
      Voting.create!(
        :title => "Title",
        :description => "Description",
        :status => 2
      )
    ])
  end

  it "renders a list of votings" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 'finished'.to_s, :count => 2
  end
end
