class UsersController < ApplicationController
        before_filter :authorized_superadmin, :only => [:index] 
	 before_filter :authenticate, :only => [:edit, :update]
	 before_filter :correct_user, :only => [:edit, :update]


  def show
    @user = User.find(current_user.id) if signed_in?
    @goals = @user.goals
    @title = @user.name
    @goals_finished = current_user.goal_finished(current_user.id) if signed_in?
    @goals_unfinished = current_user.goal_unfinished(current_user.id) if signed_in? 
  end		

  def new
	@user = User.new
	@title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def index
   @users = User.all
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(home_path) unless current_user?(@user)
    end

    def authorized_superadmin
       redirect_to root_path unless current_user_superadmin(current_user) 
    end

end
