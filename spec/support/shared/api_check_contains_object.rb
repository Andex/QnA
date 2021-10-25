shared_examples_for 'Checkable contains object' do
  it 'contains object' do
    objects.each do |object|
      expect(resource_response[object]['id']).to eq resource.send(object).id
    end
  end
end
