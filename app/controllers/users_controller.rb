class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :show, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index    
    @users = User.all.paginate(page: params[:page], per_page: 21)
    session[:get_request] = request.url
  end

  def show
    @user = User.find(params[:id])
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
      redirect_to session[:get_request]
    else
      flash[:success] = "Delete user #{session[:get_name]} faild"
      redirect_to users_url
    end
    session.delete(:get_name)
    session.delete(:get_request)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url
      flash[:error_nor] = "Please sign in."
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
