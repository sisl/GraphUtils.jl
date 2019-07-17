module Connectivity

using LightGraphs

export
    is_leaf_node

"""
    `is_leaf_node(G,v)`

    Inputs:
        `G` - graph
        `v` - query vertex

    Outputs:
        returns `true` if vertex v has no inneighbors
"""
is_leaf_node(G,v) = length(inneighbors(G,v)) == 0

end
