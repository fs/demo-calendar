class Event < ActiveRecord::Base
  
  validates_presence_of :title, :starts_at, :ends_at

  attr_accessible :starts_at, :ends_at, :title, :description
  
  named_scope :ordered, :order => 'starts_at'

end
