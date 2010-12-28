class Calendar

  attr_accessor :title,:events


  def initialize( xml)
    @title = xml.xpath(".//xmlns:feed/xmlns:title").inner_text
    @events = []
    xml.xpath(".//xmlns:entry").each do |entry|
      @events.push(Event.new(entry))      
    end
  end
end
