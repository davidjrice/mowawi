# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  require 'digest/md5'
  
  def gravatar_for(user)
    image_tag("http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.new(user.email)}", :size => "40x40", :alt => "#{user.login}'s avatar")
  end
  
  def admin_logged_in?
    logged_in? && current_user.admin?
  end
end
