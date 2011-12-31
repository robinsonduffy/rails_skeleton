require 'spec_helper'

describe UsersController do
  render_views
  describe "GET 'new'" do
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Create New User")
    end
  end
  
  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        @attr = { :email => "", :password => "", :password_confirmation => "" }
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Create New User")
      end
      
      it "should render the user create form again" do
        post :create, :user => @attr
        response.should render_template(:new)
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar" }
      end
      
      it "should create a new user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user index" do
        post :create, :user => @attr
        response.should redirect_to(users_path)
      end
      
      it "should display a success message" do
        post :create, :user => @attr
        flash[:success].should =~ /created user/i
      end
    end
  end

end
