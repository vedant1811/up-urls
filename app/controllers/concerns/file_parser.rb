require 'thread'
require 'net/http'
require 'net/ping'

SOURCES = [
  "http://avidcore.s3-us-west-2.amazonaws.com/b1.txt",
  "http://avidcore.s3-us-west-2.amazonaws.com/b2.txt",
  "http://avidcore.s3-us-west-2.amazonaws.com/b9.txt",
]

class FileParser

  def initialize
    # a queue to implement a producer and consumer
    @urls = Queue.new

    # a shared boolean variable
    @exitable = false

    parse_sources

    create_webpages
  end

  def create_webpages
    4.times do |i|
      Thread.new do
        while !@exitable || !@urls.empty?
          puts "pop---"

          # consume from queue
          url = @urls.pop

          puts "----pop"

          # pinger = Net::Ping::External.new(url)
          status = up?(url) ? 'live' : 'down'

          puts "#{url}-> #{status}"

          page = Webpage.find_or_initialize_by url: url
          page.status = status
          page.save!
        end
      end
    end
  end

  def parse_sources
    SOURCES.each do |source|
      Thread.new do
        pages = url_to_list(source)
        puts "#{source} => [#{pages.join(', ')}]"

        # produce to queue
        pages.each { |page| @urls << page }

        @exitable = true
      end
    end
  end

  def url_to_list(url)
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
          URI.parse(url).host
        else
          url
        end
      end
  end

  def up?(site)
    http = Net::HTTP.new(site)
    http.open_timeout = 2
    http.head('/')
    true
  rescue => e
    puts "#{site} error -> #{e.class} #{e.message}"
    false
  end
end
