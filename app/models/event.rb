class Event < ActiveRecord::Base
  
  MAX_LENGTH = 3.days
  
  has_many :events_uploads, :dependent => :destroy
  has_many :uploads, :through => :events_uploads
  
  validates_presence_of :title, :starts_at, :ends_at
  validate :ends_at_greater_than_starts_at, :length_of_event

  attr_accessible :starts_at, :ends_at, :title, :description
  
  named_scope :ordered, :order => 'starts_at'
  named_scope :between, lambda{ |start_time, end_time| {:conditions => ['(:start_time >= starts_at AND :start_time < ends_at) OR (:end_time > starts_at AND :end_time <= ends_at) OR (starts_at BETWEEN :start_time AND :end_time)', {:start_time => start_time, :end_time => end_time}]}}
  
  def length
    (ends_at - starts_at)/60
  end
  
  def starts_at_min
    starts_at.hour * 60 + starts_at.min
  end
  
  def split(start_time = nil, end_time = nil)
    e = self.clone
    e.id = self.id
    e.starts_at =  [e.starts_at, start_time].max if start_time
    e.ends_at =  [e.ends_at, end_time].min if end_time
    current_day = e.starts_at.end_of_day + 1
    splitted = []
    while e.ends_at > current_day
      ne = e.clone
      ne.id = e.id
      ne.ends_at = current_day
      splitted << ne
      e.starts_at = current_day
      current_day += 1.day
    end
    splitted << e
    splitted
  end
  
  protected

  def ends_at_greater_than_starts_at
    errors.add(:ends_at, "must be greater than start time") if ends_at and starts_at and ends_at <= starts_at
  end
  
  def length_of_event
    errors.add(:length, "must be less than #{MAX_LENGTH.inspect}") if ends_at and starts_at and ends_at - starts_at > MAX_LENGTH
  end
  

end
