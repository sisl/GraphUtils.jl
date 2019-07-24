module Sorting

using LightGraphs

export
    topological_sort,
    find_index_in_sorted_array,
    insert_to_sorted_array!

"""
    `topological_sort(G)`

Returns a topological sort of the vertices of a graph, with the property that
v1 < v2 iff there is not forward path through the graph from v2 to v1.
G must be non-cyclic. Can handle disjoint graphs.
"""
function topological_sort(G)
    @assert(!is_cyclic(G))
    frontier = Set{Int}(rand(1:nv(G)))
    # explored = Set{Int}()
    explored = fill!(Vector{Bool}(undef,nv(G)), false)
    ordering = []
    while any(explored .!= true)
        while length(frontier) > 0
            v = pop!(frontier)
            tip = true # check whether all downstream nodes are explored
            for v2 in inneighbors(G,v)
                if !explored[v2]
                    tip = false
                    push!(frontier,v2)
                    break
                end
            end
            if tip == true
                # push!(explored,v)
                explored[v] = true
                push!(ordering, v)
                for v2 in outneighbors(G,v)
                    push!(frontier,v2)
                end
            end
        end
        for v in 1:nv(G)
            if !explored[v]
                push!(frontier, v)
            end
        end
    end
    ordering
end

"""
    `find_index_in_sorted_array(array, x)`

    Assumes that array is already sorted. Returns index at which x would need to
    be inserted in order to maintain ordering of array. Chooses the smallest
    index in the case of a tie.
"""
function find_index_in_sorted_array(array, x)
    A = 0
    C = length(array)+1
    B = max(1,Int(round((A+C) / 2)))
    while C-A > 1
        if x < array[B] || ( !(array[B] < x) && !(x < array[B]))
            A = A
            C = B
            B = Int(ceil((A+C) / 2))
        else
            A = B
            C = C
            B = Int(ceil((A+C) / 2))
        end
    end
    return B
end

"""
    `insert_to_sorted_array!(array, x)`

    Assumes that array is already sorted. Inserts new element x so that
    array remains sorted. Requires that Base.isless(a::C,b::C) where
    C==typeof(x) be implemented.
"""
function insert_to_sorted_array!(array, x)
    B = find_index_in_sorted_array(array, x)
    insert!(array, B, x)
    array
end

end # End of module GraphSorting
