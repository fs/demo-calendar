class UploadsController < ApplicationController
  def index
    @uploads = Upload.all
  end
  
  def show
    @upload = Upload.find(params[:id])
  end
  
  def new
    @upload = Upload.new
  end
  
  def create
    @upload = Upload.new(params[:upload])
    if @upload.save
      flash[:notice] = "Successfully created upload."
      redirect_to @upload
    else
      render :action => 'new'
    end
  end
  
  def edit
    @upload = Upload.find(params[:id])
  end
  
  def update
    @upload = Upload.find(params[:id])
    if @upload.update_attributes(params[:upload])
      flash[:notice] = "Successfully updated upload."
      redirect_to @upload
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
    flash[:notice] = "Successfully destroyed upload."
    redirect_to uploads_url
  end
end
