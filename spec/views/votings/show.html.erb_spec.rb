require 'rails_helper'

RSpec.describe "votings/show", type: :view do
  before(:each) do
    @voting = assign(:voting, Voting.create!(
      :title => "Title",
      :description => "Description",
      :status => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/finished/)
  end
end
