class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    if current_user&.is_author?(@file.record)
      @file.purge
      flash.now.notice = 'Your file was deleted.'
    end
  end
end
