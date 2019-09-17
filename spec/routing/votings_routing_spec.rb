require "rails_helper"

RSpec.describe VotingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/votings").to route_to("votings#index")
    end

    it "routes to #new" do
      expect(:get => "/votings/new").to route_to("votings#new")
    end

    it "routes to #show" do
      expect(:get => "/votings/1").to route_to("votings#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/votings/1/edit").to route_to("votings#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/votings").to route_to("votings#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/votings/1").to route_to("votings#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/votings/1").to route_to("votings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/votings/1").to route_to("votings#destroy", :id => "1")
    end
  end
end
