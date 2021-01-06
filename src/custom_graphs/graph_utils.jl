################################################################################
################################### Utilities ##################################
################################################################################

export
    get_nodes_of_type,
    transplant!,
    forward_pass!,
    backward_pass!,

    validate_edge,
    validate_indegree,
    validate_outdegree,
    validate_predecessor_type,
    validate_successor_type,

    matches_template,
	required_predecessors,
	required_successors,
	num_required_predecessors,
	num_required_successors,
    eligible_successors,
    eligible_predecessors,
	num_eligible_predecessors,
	num_eligible_successors

"""
    transplant!(graph,old_graph,id)

Share node with `id` in `old_graph` to `graph` with the same id.
"""
function transplant!(graph,old_graph,id)
    add_node!(graph,get_node(old_graph,id),id)
end

get_nodes_of_type(g::AbstractCustomNGraph,T) = Dict(id=>get_node(g, id) for id in get_vtx_ids(g) if isa(id,T))

function forward_pass!(g::AbstractCustomNGraph,init_function,update_function)
    init_function(g)
    for v in topological_sort_by_dfs(g)
        update_function(g,v)
    end
    return g
end
function backward_pass!(g::AbstractCustomNGraph,init_function,update_function)
    init_function(g)
    for v in reverse(topological_sort_by_dfs(g))
        update_function(g,v)
    end
    return g
end



"""
	matches_template(template,node)

Checks if a candidate `node` satisfies the criteria encoded by `template`.
"""
matches_template(template::Type{T},node::Type{S}) where {T,S} = S<:T
matches_template(template::Type{T},node::S) where {T,S} = S<:T
matches_template(template,node) = matches_template(typeof(template),node)
matches_template(template::Tuple,node) = any(map(t->matches_template(t,node), template))

"""
	required_predecessors(node)

Identifies the types (and how many) of required predecessors to `node`
Return type: `Dict{DataType,Int}`
"""
function required_predecessors end

"""
	required_successors(node)

Identifies the types (and how many) of required successors to `node`
Return type: `Dict{DataType,Int}`
"""
function required_successors end

"""
	eligible_predecessors(node)

Identifies the types (and how many) of eligible predecessors to `node`
Return type: `Dict{DataType,Int}`
"""
function eligible_predecessors end

"""
	eligible_successors(node)

Identifies the types (and how many) of eligible successors to `node`
Return type: `Dict{DataType,Int}`
"""
function eligible_successors end


"""
	num_required_predecessors(node)

Returns the total number of required predecessors to `node`.
"""
function num_required_predecessors(node)
	n = 1
	for (key,val) in required_predecessors(node)
		n += val
	end
	n
end

"""
	num_required_successors(node)

Returns the total number of required successors to `node`.
"""
function num_required_successors(node)
	n = 1
	for (key,val) in required_successors(node)
		n += val
	end
	n
end

"""
	num_eligible_predecessors(node)

Returns the total number of eligible predecessors to `node`.
"""
function num_eligible_predecessors(node)
	n = 1
	for (key,val) in eligible_predecessors(node)
		n += val
	end
	n
end

"""
	num_eligible_successors(node)

Returns the total number of eligible successors to `node`.
"""
function num_eligible_successors(node)
	n = 1
	for (key,val) in eligible_successors(node)
		n += val
	end
	n
end

illegal_edge_msg(n1,n2) = "Edges from `$(typeof(n1))` → `$(typeof(n2))` are illegal"
illegal_indegree_msg(n,val,lo,hi) = "`$(typeof(n))` nodes should $lo ≦ indegree(n) ≦ $hi, but indegree(n) = val"
illegal_outdegree_msg(n,val,lo,hi) = "`$(typeof(n))` nodes should $lo ≦ outdegree(n) ≦ $hi, but indegree(n) = val"

"""
	validate_edge(n1,n2)

For an edge (n1) --> (n2), checks whether the edge is legal and the nodes
"agree".
"""
function validate_edge(n1,n2)
    return false
end
indegree_bounds(n,g,v) = (0,0)
outdegree_bounds(n,g,v) = (0,0)
function validate_indegree(n,g,v)
    lo,hi = indegree_bounds(n,g,v)
    @assert (lo <= indegree(g,v) <= hi) illegal_indegree_msg(n,indegree(g,v),lo,hi)
end
function validate_outdegree(n,g,v)
    lo,hi = outdegree_bounds(n,g,v)
    @assert (lo <= outdegree(g,v) <= hi) illegal_outdegree_msg(n,outdegree(g,v),lo,hi)
end
function validate_predecessor_type(n,pred,T)
    @assert isa(T,pred) illegal_edge_msg(pred,n)
end
function validate_successor_type(n,succ,T)
    @assert isa(T,succ) illegal_edge_msg(n,succ)
end


function print_tree_level(io,tree,v,start,f=summary,spacing=" ")
    println(io,start,f(get_node(tree,v)))
    for vp in outneighbors(tree,v)
        print_tree_level(io,tree,vp,string(start,spacing),f,spacing)
    end
end
function Base.print(io::IO,tree::AbstractCustomTree,f=summary,spacing=" ")
    @assert !is_cyclic(tree)
    println(io,typeof(tree))
    for v in get_all_root_nodes(tree)
        print_tree_level(io,tree,v,"",f,spacing)
    end
end
