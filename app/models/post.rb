class Post < ActiveRecord::Base

  belongs_to :account
  
  validates_presence_of :title
  validates_presence_of :body
  validates_presence_of :account_id

end
