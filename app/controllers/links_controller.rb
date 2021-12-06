class LinksController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @link = Link.find(params[:id])

    @link.destroy
    flash.now.notice = 'Your link was deleted.'
  end
end
