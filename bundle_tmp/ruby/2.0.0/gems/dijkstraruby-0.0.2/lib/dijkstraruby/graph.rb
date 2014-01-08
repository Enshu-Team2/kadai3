# encoding: UTF-8
#
# this class is responsible to calculate the shorthest path
module Dijkstraruby
  class Graph

    attr_reader :vertices

    def initialize(graph)
      initialize_vertices
      @edges = {}
      format_graph_values graph
      @dijkstra_source = nil
    end

    def dijkstra(source)
      vertex_values = @vertices.values
      @vertices[source].set_zero_for_initial_vertice

      until vertex_values.empty?
        initial_vertice = get_vertices_distances vertex_values
        break if initial_vertice.distance == Float::INFINITY
        vertex_values.delete(initial_vertice)
      end

      @dijkstra_source = source
    end

    def shortest_path(start, finish)
      dijkstra(start) unless @dijkstra_source == start
      path = []
      first_array_element = finish
      while first_array_element
        path.unshift(first_array_element)
        first_array_element = @vertices[first_array_element].prev_vertice
      end
      [path, @vertices[finish].distance]
    end

    private

    def get_vertices_distances(vertex_values)
      initial_vertice = vertex_values.min_by { |vertex| vertex.distance }
      initial_vertice.neighbours.each do |v|
        vv = @vertices[v]
        alt = initial_vertice.distance + @edges[[initial_vertice.name, v]]
        if vertex_values.include?(vv) && alt < vv.distance
          vv.change_distance_and_previous alt, initial_vertice
        end
      end
      initial_vertice
    end

    def format_graph_values(graph)
      graph.each do |(v1, v2, dist)|
        @vertices[v1].neighbours << v2
        @vertices[v2].neighbours << v1
        @edges[[v1, v2]] = @edges[[v2, v1]] = dist
      end
    end

    def initialize_vertices
      @vertices = Hash.new { |h, k| h[k] = Vertex.new(k, [], Float::INFINITY) }
    end
  end
end
