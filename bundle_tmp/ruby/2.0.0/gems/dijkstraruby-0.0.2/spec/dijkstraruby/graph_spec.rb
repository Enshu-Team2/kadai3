# encoding: UTF-8
require 'spec_helper'

module Dijkstraruby
  describe Graph do

    let(:graph) do
      Graph.new(
        [
          [:a, :b, 7],
          [:a, :c, 9],
          [:a, :f, 14],
          [:b, :c, 10],
          [:b, :d, 15],
          [:c, :d, 11],
          [:c, :f, 2],
          [:d, :e, 6],
          [:e, :f, 9]]
      )
    end

    let(:graph_result) { graph.shortest_path(:a, :e) }

    it 'should contain its neighbours for some vertices' do
      expect(graph.vertices[:a].neighbours).to eq([:b, :c, :f ])
      expect(graph.vertices[:b].neighbours).to eq([:a, :c, :d ])
    end

    it 'should return the shorthest cost value' do
      expect(graph_result[1]).to eq(20)
    end

    it 'should return shorthesth route nodes ' do
      format_result = graph_result[0].join(' -> ')
      expect(format_result).to eq('a -> c -> f -> e')
    end

  end
end
