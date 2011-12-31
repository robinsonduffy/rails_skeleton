require 'spec_helper'

describe UsersController do
  render_views
  describe "GET 'new'" do
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Create New User")
    end
  end
  
  

end
