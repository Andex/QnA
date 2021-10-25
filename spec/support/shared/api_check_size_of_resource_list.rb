shared_examples_for 'Checkable size of resource list' do
  it 'returns list of all contents' do
    resource_contents.each do |content|
      expect(resource_response[content].size).to eq resource.send(content).size
    end
  end
end
