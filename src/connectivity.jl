# module Connectivity

# using LightGraphs

export
    is_root_node,
    is_terminal_node,
    get_all_root_nodes,
    get_dist_matrix

"""
    `is_root_node(G,v)`

    Inputs:
        `G` - graph
        `v` - query vertex

    Outputs:
        returns `true` if vertex v has no inneighbors
"""
is_root_node(G,v) = length(inneighbors(G,v)) == 0

"""
    `isroot_node(G,v)`

    Inputs:
        `G` - graph
        `v` - query vertex

    Outputs:
        returns `true` if vertex v has no outneighbors
"""
is_terminal_node(G,v) = length(outneighbors(G,v)) == 0

"""
    `get_all_root_nodes`
"""
function get_all_root_nodes(G)
    root_nodes = Set{Int}()
    for v in vertices(G)
        if is_terminal_node(G,v)
            push!(root_nodes,v)
        end
    end
    return root_nodes
end

"""
    `get_dist_matrix(G)`

    Get the distance matrix corresponding to the edge weights of a graph
"""
function get_dist_matrix(G)
    distmx = zeros(Float64,nv(G),nv(G))
    for v in vertices(G)
        distmx[v,:] .= dijkstra_shortest_paths(G,v).dists
    end
    distmx
end
function get_dist_matrix(graph::G,weight_mtx::M) where {G,M}
    D = zeros(Int,nv(graph),nv(graph))
    for v1 in vertices(graph)
        ds = dijkstra_shortest_paths(graph,v1,weight_mtx)
        D[v1,:] = ds.dists
    end
    D
end

# end
