class UsersController < ApplicationController
  def new
    @title = "Create New User"
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Created User (#{@user.email})"
      redirect_to users_path
    else
      @title = "Create New User"
      render :new
    end
  end
end
