require "gdata"

class CalendarController < ApplicationController
include CalendarHelper
  def show
    client = GData::Client::Calendar.new
    client.clientlogin(@@gmail_email, @@gmail_pass )
    feed       = Nokogiri::XML(client.get('https://www.google.com/calendar/feeds/default').body)
    @calendars = []

    i          = 0
    feed.xpath("//xmlns:entry/xmlns:content/@src").each do |xml|
      if (i > 0) && (i <4)
        @calendars.push(Calendar.new(Nokogiri::XML(client.get(xml.to_s).body)))
      end
      i = i+1
    end

    @events_by_days = Hash.new
    @calendars.each do |calendar|
      calendar.events.each do |event|
        if ((event.start_day <=> get_date_part_of_time( Time.now)) >= 0)
          if !@events_by_days.has_key?(event.start_day)
            puts 'creating new array '
            puts event
            @events_by_days[event.start_day] = [event]
          else
            @events_by_days[event.start_day] << event
            puts 'adding to array '
            puts event
          end
        end
      end
    end
    @events_by_days.keys.sort
    puts @events_by_days.to_s


  end
end
