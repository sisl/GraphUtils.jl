export
    AbstractCustomGraph,
    AbstractCustomDiGraph,
    AbstractCustomTree,

    get_graph,
    get_vtx_ids,
    get_vtx_map,
    get_nodes,

    get_vtx,
    get_vtx_id,
    get_node,
    get_parent,

    set_vtx_map!,
    insert_to_vtx_map!,

    replace_node!,
    add_node!,
    add_child!,
    add_parent!,
    delete_node!,
    delete_nodes!,

    get_nodes_of_type,

    forward_pass!,
    backward_pass!


abstract type AbstractCustomGraph{G,N,I} <: AbstractGraph{Int} end
const AbstractCustomDiGraph{N,I} = AbstractCustomGraph{DiGraph,N,I}

_graph_type(::AbstractCustomGraph{G,N,I}) where {G,N,I}  = G
_node_type(::AbstractCustomGraph{G,N,I}) where {G,N,I}   = N
_id_type(::AbstractCustomGraph{G,N,I}) where {G,N,I}     = I

get_graph(g::AbstractCustomGraph)   = g.graph
get_vtx_ids(g::AbstractCustomGraph) = g.vtx_ids
get_vtx_map(g::AbstractCustomGraph) = g.vtx_map
get_nodes(g::AbstractCustomGraph)   = g.nodes

Base.zero(g::G) where {G<:AbstractCustomGraph} = G(graph=_graph_type(g)())

get_vtx(g::AbstractCustomGraph,v::Int) = v
get_vtx(g::AbstractCustomGraph{G,N,I},id::I) where {G,N,I} = get(get_vtx_map(g), id, -1)
# get_vtx(g::CustomGraph,node::Node) = get_vtx(g,node.id)
get_vtx_id(g::AbstractCustomGraph,v::Int)             = get_vtx_ids(g)[v]
get_node(g::AbstractCustomGraph,v) = get_nodes(g)[get_vtx(g,v)]

for op in [:edgetype,:ne,:nv,:vertices,:edges,:is_cyclic,:topological_sort_by_dfs,:is_directed]
    @eval LightGraphs.$op(g::AbstractCustomGraph) = $op(get_graph(g))
end
for op in [:outneighbors,:inneighbors,:indegree,:outdegree,:has_vertex]
    @eval LightGraphs.$op(g::AbstractCustomGraph,v::Int) = $op(get_graph(g),v)
    @eval LightGraphs.$op(g::AbstractCustomGraph,id) = $op(g,get_vtx(g,id))
end
for op in [:has_edge,:add_edge!,:rem_edge!]
    @eval LightGraphs.$op(s::AbstractCustomGraph,u,v) = $op(get_graph(s),get_vtx(s,u),get_vtx(s,v))
end

abstract type AbstractCustomTree{N,I} <: AbstractCustomDiGraph{N,I} end
get_parent(g::AbstractCustomTree,v) = get(inneighbors(g,v),1,-1)
function LightGraphs.add_edge!(g::AbstractCustomTree,u,v)
    if has_vertex(g,get_parent(g,v)) || get_vtx(g,u) == get_vtx(g,v)
        return false
    end
    add_edge!(get_graph(g),get_vtx(g,u),get_vtx(g,v))
end

function set_vtx_map!(g::AbstractCustomGraph,node,id,v::Int)
    @assert nv(g) >= v
    get_vtx_map(g)[id] = v
    get_nodes(g)[v] = node
end
function insert_to_vtx_map!(g::AbstractCustomGraph,node,id,idx::Int=nv(g))
    push!(get_vtx_ids(g), id)
    push!(get_nodes(g), node)
    set_vtx_map!(g,node,id,idx)
end

# for op in node_accessor_interface
#     @eval $op(g::AbstractCustomGraph,v) = $op(get_node(g,v))
#     @eval $op(g::AbstractCustomGraph) = map(v->$op(get_node(g,v)), vertices(g))
# end
# for op in node_mutator_interface
#     @eval $op(g::AbstractCustomGraph,v,val) = $op(get_node(g,v),val)
#     @eval $op(g::AbstractCustomGraph,val) = begin
#         for v in vertices(g)
#             $op(get_node(g,v),val)
#         end
#     end
# end

"""
    replace_node!(g::AbstractCustomGraph{G,N,I},node::N,id::I) where {G,N,I}

Replace the current node associated with `id` with the new node `node`.
"""
function replace_node!(g::AbstractCustomGraph{G,N,I},node::N,id::I) where {G,N,I}
    v = get_vtx(g, id)
    @assert v != -1 "node id $(string(id)) is not in graph and therefore cannot be replaced"
    set_vtx_map!(g,node,id,v)
    node
end

"""
    add_node!(g::AbstractCustomGraph{G,N,I},node::N,id::I) where {G,N,I}

Add `node` to `g` with associated `id`.
"""
function add_node!(g::AbstractCustomGraph{G,N,I},node::N,id::I) where {G,N,I}
    @assert get_vtx(g, id) == -1 "Trying to add $(string(id)) => $(string(node)) to g, but $(string(id)) => $(string(get_node(g,id))) already exists"
    add_vertex!(get_graph(g))
    insert_to_vtx_map!(g,node,id,nv(g))
    node
end
"""
    function add_child!(graph,parent,node,id)

add node `child` to `graph` with id `id`, then add edge `parent` → `child`
"""
function add_child!(g::AbstractCustomGraph{G,N,I},parent,child::N,id::I) where {G,N,I}
    add_node!(g,child,id)
    add_edge!(g,parent,id)
end
"""
    function add_parent!(graph,child,parent,id)

add node `parent` to `graph` with id `id`, then add edge `parent` → `child`
"""
function add_parent!(g::AbstractCustomGraph{G,N,I},child,parent::N,id::I) where {G,N,I}
    add_node!(g,parent,id)
    add_edge!(g,id,child)
end

"""
    delete_node!

removes a node (by id) from g.
"""
function delete_node!(g::AbstractCustomGraph{G,N,I}, id::I) where {G,N,I}
    v = get_vtx(g, id)
    rem_vertex!(get_graph(g), v)
    deleteat!(get_nodes(g), v)
    delete!(get_vtx_map(g), id)
    deleteat!(get_vtx_ids(g), v)
    for vtx in v:nv(get_graph(g))
        node_id = get_vtx_ids(g)[vtx]
        get_vtx_map(g)[node_id] = vtx
    end
    g
end
delete_node!(g::AbstractCustomGraph, v) = delete_node!(g,get_vtx_id(g,v))
function delete_nodes!(g::AbstractCustomGraph, vtxs::Vector)
    node_ids = map(v->get_vtx_id(g,v), vtxs)
    for id in node_ids
        delete_node!(g,id)
    end
    g
end


get_nodes_of_type(g::AbstractCustomGraph,T) = Dict(id=>get_node(g, id) for id in get_vtx_ids(g) if isa(id,T))

function forward_pass!(g::AbstractCustomGraph,init_function,update_function)
    init_function(g)
    for v in topological_sort_by_dfs(g)
        updater(g,v)
    end
    return g
end
function backward_pass!(g::AbstractCustomGraph,init_function,update_function)
    init_function(g)
    for v in reverse(topological_sort_by_dfs(g))
        updater(g,v)
    end
    return g
end

"""
    CustomGraph

An example concrete subtype of `AbstractCustomGraph`.
"""
@with_kw struct CustomGraph{G<:AbstractGraph,N,I} <: AbstractCustomGraph{G,N,I}
    graph               ::G                     = DiGraph()
    nodes               ::Vector{N}             = Vector{N}()
    vtx_map             ::Dict{I,Int}           = Dict{I,Int}()
    vtx_ids             ::Vector{I}             = Vector{I}() # maps vertex uid to actual graph node
end

"""
    CustomTree

An example concrete subtype of `AbstractCustomTree`.
"""
@with_kw struct CustomTree{N,I} <: AbstractCustomTree{N,I}
    graph               ::DiGraph               = DiGraph()
    nodes               ::Vector{N}             = Vector{N}()
    vtx_map             ::Dict{I,Int}           = Dict{I,Int}()
    vtx_ids             ::Vector{I}             = Vector{I}()
end


"""
    CustomGraph{G,N,E,ID}

Custom graph type with custom edge and node types.
"""
@with_kw_noshow struct DoubleCustomGraph{G,N,E,ID} <: AbstractCustomGraph{G,N,ID}
    graph               ::G                     = G()
    nodes               ::Vector{N}             = Vector{N}()
    vtx_map             ::Dict{ID,Int}          = Dict{ID,Int}()
    vtx_ids             ::Vector{ID}            = Vector{ID}()
    inedges             ::Vector{Dict{Int,E}}   = Vector{Dict{Int,E}}()
    outedges            ::Vector{Dict{Int,E}}   = Vector{Dict{Int,E}}()
end

in_edges(g::DoubleCustomGraph) = g.inedges
in_edges(g::DoubleCustomGraph, v) = in_edges(g)[get_vtx(g,v)]
in_edge(g::DoubleCustomGraph, v, u) = in_edges(g,v)[get_vtx(g,u)]
function set_edge!(g::DoubleCustomGraph{G,N,E,ID}, edge::E, u, v) where {G,N,E,ID}
    out_edges(g,u)[get_vtx(g,v)] = edge
    in_edges(g,v)[get_vtx(g,u)] = edge
    # TODO for undirected graph, insert reversed edge too?
    edge
end
out_edges(g::DoubleCustomGraph) = g.outedges
out_edges(g::DoubleCustomGraph, v) = out_edges(g)[get_vtx(g,v)]
out_edge(g::DoubleCustomGraph, u, v) = out_edges(g,u)[get_vtx(g,v)]
function get_edge(g::DoubleCustomGraph,u,v)
    @assert has_edge(g,u,v) "Edge $u → $v does not exist."
    return out_edge(g,u,v)
end
get_edge(g::DoubleCustomGraph,edge) = get_edge(g,edge_source(edge),edge_target(edge))

struct CustomEdge{E,ID}
    src::ID
    dst::ID
    edge::E
end
# Edge interface
edge_source(edge) = edge.src
edge_target(edge) = edge.dst

function add_node!(g::DoubleCustomGraph{G,N,E,ID},node::N,id::ID) where {G,N,E,ID}
    @assert get_vtx(g, id) == -1 "Trying to add $(string(id)) => $(string(node)) to g, but $(string(id)) => $(string(get_node(g,id))) already exists"
    add_vertex!(get_graph(g))
    insert_to_vtx_map!(g,node,id,nv(g))
    push!(g.outedges, Dict{Int,E}())
    push!(g.inedges, Dict{Int,E}())
    node
end
function delete_node!(g::DoubleCustomGraph{G,N,E,ID},id::ID) where {G,N,E,ID}
    if !has_vertex(g,id)
        return g
    end
    v = get_vtx(g, id)
    rem_vertex!(get_graph(g), v)
    deleteat!(get_nodes(g), v)
    delete!(get_vtx_map(g), id)
    deleteat!(get_vtx_ids(g), v)
    for vtx in v:nv(get_graph(g))
        node_id = get_vtx_ids(g)[vtx]
        get_vtx_map(g)[node_id] = vtx
    end
    deleteat!(in_edges(g),v)
    deleteat!(out_edges(g),v)
    g
end

function LightGraphs.add_edge!(g::DoubleCustomGraph{G,N,E,ID},edge::E,
        u=edge_source(edge),v=edge_target(edge)) where {G,N,E,ID}
    @assert !has_edge(g,u,v) "graph already has an edge $u → $v"
    @assert has_vertex(g,u) "Vertex $u is not in graph."
    @assert has_vertex(g,v) "Vertex $v is not in graph."
    add_edge!(get_graph(g),get_vtx(g,u),get_vtx(g,v))
    set_edge!(g,edge,u,v)
    edge
end
function replace_edge!(g::DoubleCustomGraph{G,N,E,ID},edge::E,u,v) where {G,N,E,ID}
    @assert has_edge(g,u,v) "graph does not have edge $u → $v"
    set_edge!(g,edge,u,v)
end
function replace_edge!(g::DoubleCustomGraph{G,N,E,ID},edge::E,old_edge) where {G,N,E,ID}
    replace_edge!(g,edge,edge_source(old_edge),edge_target(old_edge))
end

function LightGraphs.rem_edge!(g::DoubleCustomGraph, u, v)
    if !has_edge(g,u,v)
        return g
    end
    delete!(out_edges(g,u),v)
    delete!(in_edges(g,v),u)
    rem_edge!(get_graph(g),get_vtx(g,u),get_vtx(g,v))
    g
end
