module CalendarHelper

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
