shared_examples_for 'api_check_size_of_resource_list' do
  it 'returns list of all contents' do
    resource_contents.each do |content|
      expect(resource_response[content].size).to eq resource.send(content).size
    end
  end
end
