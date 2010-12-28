require "gdata"

class CalendarController < ApplicationController
  include CalendarHelper
  filter_parameter_logging :pass

  def show
    gmail_email = params[:email]
    gmail_pass  = params[:pass]

    if (gmail_email.nil? ||gmail_email.empty? ||gmail_pass.nil? || gmail_pass.empty?) then
      render 'calendar/_form'
    else
      client = sign_in(gmail_email, gmail_pass)
      puts client
      if client.nil? then
        render 'calendar/_form'
        return
      end
      get_client_calendars(client)
      get_events_by_days()
    end
  end


  private

  def get_client_calendars(client)
    feed       = Nokogiri::XML(client.get('https://www.google.com/calendar/feeds/default').body)
    @calendars = []
    i          = 0
    feed.xpath("//xmlns:entry/xmlns:content/@src").each do |xml|
      if (i > 0)
        @calendars.push(Calendar.new(Nokogiri::XML(client.get(xml.to_s).body)))
      end
      i = i+1
    end
  end

  def sign_in(gmail_email, gmail_pass)

    begin
      client = GData::Client::Calendar.new
      client.clientlogin(gmail_email, gmail_pass)
    rescue
      flash.now[:error] = "Invalid email/password combination."
      return nil
    end
    client
  end

  def get_events_by_days
    @events_by_days = Hash.new
    @calendars.each do |calendar|
      calendar.events.each do |event|
        if ((event.start_day <=> get_date_part_of_time(Time.now)) >= 0)
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
  end

end
