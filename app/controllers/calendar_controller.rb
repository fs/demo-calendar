class CalendarController < ApplicationController
  def index
    @uploads = Upload.all
    render
  end
end
