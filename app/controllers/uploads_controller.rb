class UploadsController < ApplicationController
  def index
    @uploads = Upload.all
  end
  
  def show
    @upload = Upload.find(params[:id])
  end
  
  def new
    @upload = Upload.new
    render :layout => false
  end
  
  def create
    @upload = Upload.new(params[:upload])
    if @upload.save
      respond_to_parent do
        render :update do |page|
          page << 'valid.deactivate()'
          page.insert_html :bottom, 'uploads', :partial => 'upload'
        end
      end
    else
      respond_to_parent do
        render :update do |page|
          page.replace_html "errors", :partial => "errors"
          page['upload_errors'].show
          page['upload_loading'].hide
          page['upload_form_buttons'].show
        end
      end
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
