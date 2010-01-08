class CalendarController < ApplicationController
  def index
    @uploads = Upload.all
    @start_time = Time.now.midnight - 1.day
    @end_time = @start_time + 3.days
    load_events
  end
  
  def day
    @start_time = Time.parse(params[:id].gsub('-', '/'))
    @end_time = @start_time + 1.day
    load_events
    render :partial => 'day', :object => @days[0]
  end
  
  private
  
  def load_events
    events = Event.between(@start_time, @end_time).ordered
    @days = []
    day_index = 0
    event_index = 0
    current_day = @start_time
    while current_day < @end_time do
      @days << {:day => current_day, :events => []}
      next_day = current_day + 1.day
      while (event_index < events.size) and events[event_index].starts_at < next_day
        @days[-1][:events] << events[event_index]
        event_index += 1
      end
      current_day = next_day
    end
  end
end
