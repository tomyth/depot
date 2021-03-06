
require 'digest/sha2'

class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  #has_secure_password
  
  validates :password, :confirmation => true
  attr_accessor :password_confirmation
  attr_accessor :password
  validate :password_must_be_present
  
  def User.authenticate(name, password)
    logger.debug "authenticate!!!!!!!!============================================================== "
    if user = find_by_name(name)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end
  
  def User.encrypt_password(password, salt)
    logger.debug "encrypt_paaword!!!!!!!!============================================================== "
    Digest::SHA2.hexdigest(password + "wibble" +salt)
  end
  
  # 'password' is a virtual attribute
  def password=(password)
    logger.debug "pass word= method!!!!!!!!============================================================== "
    @password = password
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end
  
  private
    
    def password_must_be_present
      logger.debug "pass word present!!!!!!!!============================================================== #{hashed_password}"
      errors.add(:password, "Missing password") unless hashed_password.present?
    end
  
    def generate_salt
      logger.debug "generate salt!!!!!!!============================================================== "
      self.salt = self.object_id.to_s + rand.to_s
    end
end
