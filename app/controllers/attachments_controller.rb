class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    authorize! :destroy, @file

    @file.purge
    flash.now.notice = 'Your file was deleted.'
  end
end
