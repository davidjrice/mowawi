# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_mowawi_12345_session_id'
  
  layout 'mowawi'
  
  before_filter :login_from_cookie
  
  class AccessDenied < StandardError; end
  
  around_filter :catch_errors
  
  protected
    def self.protected_actions
      [ :edit, :update, :destroy ]
    end

  private

    def catch_errors
      begin
        yield

      rescue AccessDenied
        flash[:notice] = "You do not have access to that area."
        redirect_to '/'
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = "Sorry, can't find that record."
        redirect_to '/'
      end
    end
  
end
