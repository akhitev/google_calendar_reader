module CalendarHelper

  def group_events_by_days(calendars)
    events_by_days = Hash.new
    calendars.each do |calendar|
      calendar.events.each do |event|
        if ((event.start_day <=> get_date_part_of_time(Time.now)) >= 0)
          if !events_by_days.has_key?(event.start_day)
            puts 'creating new array '
            events_by_days[event.start_day] = [event]
          else
            events_by_days[event.start_day] << event
            puts 'adding to array '
          end
        end
      end
    end
    events_by_days
  end
  
  def to_s_hour_minute (time)
    time.strftime("%l %M %p ")
  end


  def to_s_date (time)
    time.strftime("%a %b %d %Y")
  end

  def get_date_part_of_time (time)
  Time.utc(time.year,time.month,time.day )
  end  
end
