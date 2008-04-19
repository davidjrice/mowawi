require 'digest/sha1'
class User < ActiveRecord::Base
  include AuthenticatedBase

  has_many :places
  has_many :photos
  
  validates_uniqueness_of :login, :email, :case_sensitive => false

  # Protect internal methods from mass-update with update_attributes
  attr_accessible :login, :email, :password, :password_confirmation, :time_zone, :identity_url
  
  def openid?
    !self.identity_url.nil? && !self.identity_url.blank?
  end
  
  def to_param
    login
  end

  def self.find_by_param(*args)
    find_by_login *args
  end

  def to_xml
    super( :only => [ :login, :time_zone, :last_login_at ] )
  end
  
end
