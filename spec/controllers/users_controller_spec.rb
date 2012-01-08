require 'spec_helper'

describe UsersController do
  render_views
  describe "GET 'new'" do
    describe "for non users" do
      it "should deny access" do
        get :new
        response.should redirect_to(login_path)
      end
    end
    
    describe "for non-admin users" do
      before(:each) do
        login_user(Factory(:user, :email => "nonadmin@example.com"))
      end
      
      it "should deny access" do
        get :new
        response.should redirect_to(login_path)
      end
    end
    
    describe "for admins" do
      before(:each) do
        login_user(Factory(:user, :email => "admin@example.com", :admin => true))
      end
      it "should be success" do
        get :new
        response.should be_success
      end
      
      it "should have the right title" do
        get :new
        response.should have_selector("title", :content => "Create New User")
      end
    
      it "should NOT have the admin checkbox" do
        get :new
        response.should_not have_selector("input", :type => "checkbox", :name => "user[admin]")
      end
    end
  end
  
  describe "POST 'create'" do
    
    describe "for non users" do
      it "should deny access" do
        post :create
        response.should redirect_to(login_path)
      end
    end
    
    describe "for non-admin users" do
      before(:each) do
        login_user(Factory(:user, :email => "nonadmin@example.com"))
      end
      
      it "should deny access" do
        post :create
        response.should redirect_to(login_path)
      end
    end
    
    describe "for admin users" do
      before(:each) do
        login_user(Factory(:user, :email => "admin@example.com", :admin => true))
      end
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
  
  describe "GET 'index'" do
    
    describe "for non users" do
      it "should deny access" do
        get :index
        response.should redirect_to(login_path)
      end
    end
    
    describe "for non-admin users" do
      before(:each) do
        login_user(Factory(:user, :email => "nonadmin@example.com"))
      end
      
      it "should deny access" do
        get :index
        response.should redirect_to(login_path)
      end
    end
    
    describe "for admins" do
      before(:each) do
        login_user(Factory(:user, :email => "admin@example.com", :admin => true))
        @user1 = Factory(:user, :email => Factory.next(:email))
        @user2 = Factory(:user, :email => Factory.next(:email))
        @user3 = Factory(:user, :email => Factory.next(:email))
      end
    
      it "should be success" do
        get :index
        response.should be_success
      end
    
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "Users")
      end
    
      it "should list all the current users" do
        get :index
        response.should have_selector("a", :content => @user1.email, :href => edit_user_path(@user1))
        response.should have_selector("a", :content => @user2.email, :href => edit_user_path(@user2))
        response.should have_selector("a", :content => @user3.email, :href => edit_user_path(@user3))
      end
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non users" do
      it "should deny access" do
        get :edit, :id => @user
        response.should redirect_to(login_path)
      end
    end
    
    describe "for non-admin users" do
      before(:each) do
        login_user(Factory(:user, :email => "nonadmin@example.com"))
      end
      
      it "should deny access" do
        get :edit, :id => @user
        response.should redirect_to(login_path)
      end
    end
    
    describe "for admins" do
      before(:each) do
        login_user(Factory(:user, :email => "admin@example.com", :admin => true))
      end
      
      it "should be success" do
        get :edit, :id => @user
        response.should be_success
      end
    
      it "should have the right title" do
        get :edit, :id => @user
        response.should have_selector("title", :content => "Edit User")
      end
    
      it "should have a delete link" do
        get :edit, :id => @user
        response.should have_selector("a", :content => "Delete User")
      end
    end
  end
  
  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non users" do
      it "should deny access" do
        put :update, :id => @user
        response.should redirect_to(login_path)
      end
    end
    
    describe "for non-admin users" do
      before(:each) do
        login_user(Factory(:user, :email => "nonadmin@example.com"))
      end
      
      it "should deny access" do
        put :update, :id => @user
        response.should redirect_to(login_path)
      end
    end
    
    describe "for admins" do
      before(:each) do
        login_user(Factory(:user, :email => "admin@example.com", :admin => true))
      end
      
      describe "failure" do
        before(:each) do
          @attr = {:email => "", :password => "foobar", :password_confirmation => "boofar"}
        end
      
        it "should render the edit form again" do
          put :update, :id => @user, :user => @attr 
          response.should render_template(:edit)
        end
      
        it "should have the right title" do
          put :update, :id => @user, :user => @attr
          response.should have_selector("title", :content => "Edit User")
        end
      end
    
      describe "success" do
        before(:each) do
          @attr = {:email => "change@email.com", :password => "foobar", :password_confirmation => "foobar"}
        end
      
        it "should redirect to the user index" do
          put :update, :id => @user, :user => @attr
          response.should redirect_to(users_path)
        end
      
        it "should display a success message" do
          put :update, :id => @user, :user => @attr
          flash[:success] =~ /updated/i
        end
      
        it "should update the users info" do
          put :update, :id => @user, :user => @attr
          @user.reload
          @user.email.should == @attr[:email]
        end
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non users" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(login_path)
      end
    end
    
    describe "for non-admin users" do
      before(:each) do
        login_user(Factory(:user, :email => "nonadmin@example.com"))
      end
      
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(login_path)
      end
    end
    
    describe "for admins" do
      before(:each) do
        login_user(Factory(:user, :email => "admin@example.com", :admin => true))
      end
      
      it "should delete the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
    
      it "should redirect to the user index page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    
      it "should display a confirmation message" do
        delete :destroy, :id => @user
        flash[:success] =~ /deleted/i
      end
    end
  end
end
