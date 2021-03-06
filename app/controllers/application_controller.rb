class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :not_a_member
  helper_method :waiting_club_confirmation

  def current_user
    return nil if session[:user_id].nil?
    User.find session[:user_id]
  end

  def ensure_that_signed_in
    redirect_to signin_path, alert:'you should be signed in' if current_user.nil?
  end

  def not_a_member
    membership = current_user.memberships.find_by(beer_club_id: params[:id])
    if membership.nil?
      return true
    else
      return membership.confirmed ? false : true
    end
  end

  def waiting_club_confirmation
    membership = current_user.memberships.find_by(beer_club_id: params[:id])
    if membership.nil?
      return false
    else
      return membership.confirmed ? false : true
    end
  end

  def ensure_that_admin
    redirect_to :back, alert: 'You need to have admin privileges to do that' unless current_user.admin?
  end
end
