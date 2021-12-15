class ActiveStorage::BaseController
  def default_serializer_options
    {
      serializer: nil
    }
  end
end