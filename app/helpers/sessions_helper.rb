module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end


  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url
      flash[:error_nor] = "Please sign in."
    end
  end

  def sign_out
    current_user.update_attribute(:remember_token, User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  # SP Pagination
  def redirect_after_destroy_user(current_url,n)
    count_users = User.count
    get_current_page = session[current_url].to_s.split('=')
    total_record = ( get_current_page[1].to_i - 1 ) * n
    
    if count_users == total_record
      numpage = (get_current_page[1].to_i - 1).to_s
      redirect_to (session[current_url].to_s).gsub!(/[0-9]?[0-9]$/,numpage)      
    else
       redirect_to session[current_url]
    end
    session.delete(current_url)  
  end

  def redirect_after_destroy_micropost(current_url,n)
    count_users = Micropost.where("user_id = ?", current_user.id).count
    get_current_page = session[current_url].to_s.split('=')
    total_record = ( get_current_page[1].to_i - 1 ) * n
    
    if count_users == total_record
      numpage = (get_current_page[1].to_i - 1).to_s
      redirect_to (session[current_url].to_s).gsub!(/[0-9]?[0-9]$/,numpage)      
    else
       redirect_to session[current_url]
    end
    session.delete(current_url)  
  end

end