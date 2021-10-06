class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    return head :forbidden unless current_user&.is_author?(@file.record)

    @file.purge
    flash.now.notice = 'Your file was deleted.'
  end
end
