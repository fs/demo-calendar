class Upload < ActiveRecord::Base

  has_many :events_uploads, :dependent => :destroy
  has_many :events, :through => :events_uploads

  has_attached_file :attachment

end
