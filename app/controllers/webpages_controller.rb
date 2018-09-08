class WebpagesController < ApplicationController
  def run
    FileParser.new

    render json: {
        fetched: 3
      }
  end

  def show
  end
end
