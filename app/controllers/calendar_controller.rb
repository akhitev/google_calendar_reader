require "gdata"

class CalendarController < ApplicationController
  include CalendarHelper

  def show
    gmail_email = params[:email]
    gmail_pass  = params[:pass]

    xml_feeds   = params[:feeds]

    if (gmail_email.nil? ||gmail_email.empty? ||gmail_pass.nil? || gmail_pass.empty?) then
      if xml_feeds.nil?
        render 'calendar/_form'
        return
      else
        get_calendars_by_feed(xml_feeds)
      end
    else
      client = sign_in(gmail_email, gmail_pass)
      puts client
      if client.nil? then
        render 'calendar/_form'
        return
      end
      get_client_calendars(client)
    end
    @events_by_days =  group_events_by_days(@calendars)
  end

  def get_calendars_by_feed(feed)
    @calendars = []
      @calendars.push(Calendar.create_from_feed(feed))
  end


  private

  def get_client_calendars(client)
    feed       = Nokogiri::XML(client.get('https://www.google.com/calendar/feeds/default').body)
    @calendars = []
    i          = 0
    feed.xpath("//xmlns:entry/xmlns:content/@src").each do |xml|
      if (i > 0)
        @calendars.push(Calendar.new(Nokogiri::XML(client.get(xml.to_s).body)))
        puts xml.to_s
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


end
