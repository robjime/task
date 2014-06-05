class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable
  
  has_many :events
  has_many :tokens
  
  #TODO add attr_accessible lines
  
 
  def as_json(options={})
    {
      id: self.id,
      email: self.email
    }
  end
end
