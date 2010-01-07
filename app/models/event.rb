class Event < ActiveRecord::Base
  
  validates_presence_of :title, :starts_at, :ends_at

  attr_accessible :starts_at, :ends_at, :title, :description
  
  named_scope :ordered, :order => 'starts_at'
  named_scope :between, lambda{ |start_time, end_time| {:conditions => ['starts_at BETWEEN ? AND ?', start_time, end_time]}}
  
  def length
    (ends_at - starts_at)/60
  end
  
  def starts_at_min
    starts_at.hour * 60 + starts_at.min
  end

end
