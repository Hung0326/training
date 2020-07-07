class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  def index

  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'Micropost created'
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = 'Deleted'
      if session[:url_show].nil?
        redirect_after_destroy_micropost(:url_home,15)
      else
        redirect_after_destroy_micropost(:url_show,15)        
      end
    else
      flash[:warning] = 'Faild to delete'
    end
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user 
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
