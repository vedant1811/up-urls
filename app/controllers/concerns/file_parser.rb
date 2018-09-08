require 'net/http'


SOURCES = [
  "http://avidcore.s3-us-west-2.amazonaws.com/b1.txt",
  "http://avidcore.s3-us-west-2.amazonaws.com/b2.txt",
  "http://avidcore.s3-us-west-2.amazonaws.com/b9.txt",
]

URL_WITH_OR_WITHOUT_HTTP = /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/

class FileParser

  def initialize
    parse_sources
  end

  def parse_sources
    SOURCES.each do |source|
      pages = url_to_webpages(source)
      puts "#{source} => [#{pages.join(', ')}]"
    end
  end

  def url_to_webpages(url)
    url = URI.parse(url)
    req = Net::HTTP::Get.new(url.to_s)
    response = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }

    if response.code == '200'
      result = response.body
      result.split("\n")
    else
      []
    end
      .map do |url|
        if url.start_with?('http')
          url
        else
          "http://#{url}"
        end
      end
  end
end
