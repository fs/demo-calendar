module CalendarHelper
  
  def midnights_count(start_time, end_time)
    div, mod = (end_time - start_time).divmod(1.day)
    count = div
    count += 1 if start_time + mod > start_time.end_of_day + 1
    count
  end
  
  def event_height(event)
    [(14 + (event.length / 30.0 - 1) * ((event.length < 30) ? 14.0 : 16.0) + midnights_count(event.starts_at, event.ends_at) * 32).round, 798 - event_top(event)].min
  end
  
  def event_top(event)
    [32, (event.starts_at_min / 60.0 * 32.0 + 32).round].max
  end
  
end
