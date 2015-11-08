require 'spec_helper'
require Tests.model_file('link_objects')
require Tests.model_file('link')

RSpec.describe LinkObjects do
  subject do
    LinkObjects.new([
      {url: '1'},
      {url: '2'},
      {url: '3'},
      {url: '4'},
      {url: '5'},
    ])
  end

  describe "#all" do
    it 'returns all link object' do
      expect(subject.all.map(&:url)).to match_array(["1", "2", "3", "4", "5"])
    end
  end

  describe "#visible" do
    it 'returns all link object' do
      expect(subject.visible.map(&:url)).to match_array(["1", "2", "3"])
    end
  end

  describe "#hidden" do
    it 'returns all link object' do
      expect(subject.hidden.map(&:url)).to match_array(['4','5'])
    end
  end
end
