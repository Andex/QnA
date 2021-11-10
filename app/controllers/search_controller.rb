class SearchController < ApplicationController
  skip_authorization_check

  def search
    @query = params[:query]
    @resource = params[:resource]
    @result = model_klass(@resource).search(@query) if @query
  end

  def model_klass(class_name)
    class_name == 'all' ? ThinkingSphinx : class_name.classify.constantize
  end
end
