class WebpagesController < ApplicationController
  def run
    FileParser.new

    render json: {
        notice: 'Pinging all pages in the background'
      }
  end

  def show
    render json: {
        data: all_pages
      }
  end

private
  def all_pages
    Webpage.all
      .map { |page| { url: page.url, status: page.status } }
  end
end
