require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar" }
  end
  
  it "should create a new user given valid attributes" do
    User.create!(@attr)
  end
  
  describe "validations" do
    it "should require an email" do
      no_name_user = User.new(@attr.merge(:email => ' '))
      no_name_user.should_not be_valid
    end
    
    it "should require a password" do
      no_password_user = User.new(@attr.merge(:password => ' ', :password_confirmation => ' '))
      no_password_user.should_not be_valid
    end
    
    it "password confirmation must match password" do
      confirm_user = User.new(@attr.merge(:password_confirmation => 'boofar'))
      confirm_user.should_not be_valid
    end
    
    it "should require passwords that are the right length" do
      short_pass_user = User.new(@attr.merge(:password => "a"*3, :password_confirmation => "a"*3))
      short_pass_user.should_not be_valid
      long_pass_user = User.new(@attr.merge(:password => "a"*41, :password_confirmation => "a"*41))
      long_pass_user.should_not be_valid
    end
    
    it "should require a proper email address" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should_not be_valid
      end
    end
  end
      
end
