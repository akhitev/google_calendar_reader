class Event

  include CalendarHelper
  
  attr_accessor :end_time,:start_time, :where,:xml,:title


  def initialize( xml)
    puts 'event entry'
    puts xml.to_s
    @title = xml.xpath(".//xmlns:title").inner_text
    puts 'css title'
    puts xml.css("title")

    @end_time = Time.zone.parse(xml.xpath(".//gd:when/@endTime").to_s)
    @start_time = Time.zone.parse(xml.xpath(".//gd:when/@startTime").to_s)
    @where = xml.xpath(".//gd:where/@valueString")

  end


  def to_s
    'title ' + @title.to_s + " end_time" + @end_time.to_s + " start time " + @start_time.to_s
  end

  def start_day
    # Time.utc(year, month, day) => time
    get_date_part_of_time @start_time

  end



  def start_time
    to_s_hour_minute(@start_time)
    end

  def end_time
    to_s_hour_minute(@end_time)
  end

end
