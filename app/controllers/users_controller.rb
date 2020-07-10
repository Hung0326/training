class UsersController < ApplicationController
  
  before_action :signed_in_user, only: [:index, :edit, :update, :show, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index    
    @users = User.all.paginate(page: params[:page], per_page: 12)
    session[:get_request] = request.url
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 15)
    session[:url_show] = request.url
    session.delete(:url_home)
  end


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user      
    else
      flash.now[:info] = "PLease check information!"
      render 'new'
      flash.discard
    end
  end


  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user      
    else
      render 'edit'
    end
  end

  def destroy
    get_user = User.find(params[:id])
    session[:get_name] = get_user.name
    if User.find(params[:id]).destroy
      flash[:success] = "Deleted user #{session[:get_name]}"
      redirect_after_destroy_user(:get_request,24)
    else
      flash[:success] = "Delete user #{session[:get_name]} faild"
      redirect_to users_url
    end
    session.delete(:get_name)    
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end