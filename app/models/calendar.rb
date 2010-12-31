class Calendar
include CalendarHelper

  attr_accessor :title,:events,:xml_feed


  def initialize( xml)
    @xml_feed = xml
    pull_from_feed(xml)
  end

def pull_from_feed(xml)
    @title = xml.xpath(".//xmlns:feed/xmlns:title").inner_text
    @events = []
    xml.xpath(".//xmlns:entry").each do |entry|
      @events.push(Event.new(entry))
    end
end

  def self.create_from_feed( xml_feed)
    http = Net::HTTP.get_response(URI.parse(xml_feed)).body    
    calendar = Calendar.new(Nokogiri::XML(http))
    calendar.xml_feed= xml_feed
    calendar
  end

end

