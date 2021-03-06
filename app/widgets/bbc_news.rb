require 'net/http'

class BbcNews
  def initialize()
    @http = Net::HTTP.new('feeds.bbci.co.uk')
  end

  def latest_headlines()
      response = @http.request(Net::HTTP::Get.new("/news/rss.xml"))
      doc = Nokogiri::XML(response.body)
      news_headlines = [];
      doc.xpath('//channel/item').each do |news_item|
        news_headline = NewsHeadlineBuilder.BuildFrom(news_item)
        news_headlines.push(news_headline)
      end
      news_headlines
  end
end

class NewsHeadlineBuilder
  def self.BuildFrom(news_item)
    {
      title: news_item.xpath('title').text,
      description: news_item.xpath('description').text
    }
  end
end

