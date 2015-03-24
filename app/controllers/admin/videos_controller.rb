class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create    
    params.permit!
    @video = Video.new(params[:video])
    if @video.save
      flash[:success] = "You habe successfully added the video '#{@video.title}'."
      redirect_to new_admin_video_path
    else
      flash[:error] = 'You cannot add this video. Please check the errors.'
      render :new
    end      
  end
end