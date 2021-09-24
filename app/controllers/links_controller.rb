class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    return unless current_user&.is_author?(@link.linkable)

    @link.destroy
    flash.now.notice = 'Your link was deleted.'
  end
end
