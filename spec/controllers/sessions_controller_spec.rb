require 'spec_helper'

describe SessionsController do
  render_views
  describe "GET 'new'" do
    describe "for logged-in users" do
      before(:each) do
        login_user(Factory(:user))
      end
      
      it "should redirect to the root path" do
        get :new
        response.should redirect_to(root_path)
      end
    end
    
    describe "for non-logged-in users" do
      
      it "should be success" do
        get :new
        response.should be_success
      end
      
      it "should have the right title" do
        get :new
        response.should have_selector("title", :content => "Sign In")
      end
    end
  end

end
