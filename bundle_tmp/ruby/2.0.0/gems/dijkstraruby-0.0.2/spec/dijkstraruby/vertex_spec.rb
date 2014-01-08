# encoding: UTF-8
require 'spec_helper'

module Dijkstraruby
  describe Vertex do

    let(:vertex) { Vertex.new('heriberto', [], 99_999) }

    it 'should create a vertex class' do
      expect(vertex.class).to eq Vertex
    end

    it 'should have a getter and setter for name' do
      expect(vertex.name).to eq 'heriberto'
    end

  end
end
