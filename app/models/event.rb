class Event < ActiveRecord::Base

  attr_accessible :starts_at, :ends_at, :title, :description
  
  named_scope :ordered, :order => 'starts_at'

end
