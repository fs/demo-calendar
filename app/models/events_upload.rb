class EventsUpload < ActiveRecord::Base
  belongs_to :event
  belongs_to :upload
  
  validates_presence_of :event_id, :upload_id
  validates_uniqueness_of :upload_id, :scope => :event_id
end
