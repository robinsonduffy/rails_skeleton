class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :password, :password_confirmation
  
  validates :password, :presence => true, 
                       :confirmation => {:on => :create}, 
                       :length => {:within => 6..40}
  
  validates :email, :presence => true, 
                    :uniqueness => {:case_sensitve => false}
                    
end
