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

  def redirect_after_destroy_user
    get_current_page = session[:get_request].to_s.slice(-1)
    count_users = User.count

    n_page = count_users / 21.0
    

    if get_current_page == 's'
      redirect_to users_url
    else 
      get_current_page = get_current_page.to_i
      total_record = (get_current_page - 1) * 21
      if n_page        
        redirect_to session[:get_request]
      elsif (count_users == total_record) && (n_page == (get_current_page -1 ))
        # render plain: n_page

        redirect_to users_url << "?page=#{get_current_page - 1}"
      end    
    end    
  end

end
