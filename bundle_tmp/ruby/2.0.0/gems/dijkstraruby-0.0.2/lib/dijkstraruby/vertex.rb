# encoding: UTF-8
# class reponsible for vertices
#
module Dijkstraruby
  class Vertex
    attr_accessor :name, :neighbours, :distance, :prev_vertice

    def initialize(name, neighbours, distance, prev = nil)
      @name = name
      @neighbours = neighbours
      @distance = distance
      @prev_vertice = prev
    end

    def set_zero_for_initial_vertice
      @distance = 0
    end

    def change_distance_and_previous(distance, previous_vertice)
      @distance = distance
      @prev_vertice = previous_vertice.name
    end
  end
end
