class InvitationsController < ApplicationController
  before_filter :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    params.permit!

    @invitation = Invitation.new(params[:invitation].merge!(inviter_id: current_user.id))
    if @invitation.save
      AppMailer.delay.send_invitation_email(@invitation)
      flash[:success] = "You have successfully invited #{@invitation.recipient_name}."
      redirect_to new_invitation_path    
    else
      flash[:error] = 'Please check your inputs.'
      render :new
    end
  end
end