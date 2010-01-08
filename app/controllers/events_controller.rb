class EventsController < ApplicationController
  def index
    @events = Event.all
  end
  
  def show
    @event = Event.find(params[:id])
    respond_to do |wants|
      wants.html {}
      wants.js do
        render @event
      end
    end
  end
  
  def new
    @event = Event.new
    respond_to do |wants|
      wants.html{}
      wants.js do
        render :layout => false
      end
    end
  end
  
  def create
    @event = Event.new(params[:event])
    upload_ids = params[:event].delete(:upload_ids) || []
    @event.save
    @event.upload_ids = upload_ids
    respond_to do |wants|
      wants.js { }
    end
  end
  
  def edit
    @event = Event.find(params[:id])
    respond_to do |wants|
      wants.html{}
      wants.js do
        render :layout => false
      end
    end
  end
  
  def update
    @event = Event.find(params[:id])
    upload_ids = params[:event].delete(:upload_ids) || []
    @event.upload_ids = upload_ids
    respond_to do |wants|
      wants.html do
        if @event.update_attributes(params[:event])
          flash[:notice] = "Successfully updated event."
          redirect_to @event
        else
          render :action => 'edit'
        end
      end
      wants.js do
        if @event.update_attributes(params[:event])
          @success = true
        end
      end
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:notice] = "Successfully destroyed event."
    redirect_to events_url
  end
end
