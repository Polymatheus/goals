class SessionsController < ApplicationController
  def new
	@title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      redirect_back_or home_path
    end
  end

  def destroy
    sign_out
    redirect_to 'http://reachmygoals.org:3000'
  end

end
