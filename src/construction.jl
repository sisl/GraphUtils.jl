module Construction

using LightGraphs, MetaGraphs
using ..Arrays

export
    initialize_regular_vtx_grid,
    construct_vtx_grid,
    initialize_grid_graph_from_vtx_grid,
    initialize_regular_grid_graph,
    initialize_grid_graph_with_obstacles

"""
    Returns a grid graph that represents a 2D environment with regularly spaced
    rectangular obstacles
"""
function initialize_regular_vtx_grid(;
    n_obstacles_x=2,
    n_obstacles_y=2,
    obs_width = [2;2],
    obs_offset = [1;1],
    env_pad = [1;1]
    )
    # generate occupancy grid representing the environment
    o = ones(Int,obs_width[1],obs_width[2]) # obstacle region
    op = pad_matrix(o,(obs_offset[1],obs_offset[2]),0) # padded obstacles region
    A = repeat(op,n_obstacles_x,n_obstacles_y)
    Ap = pad_matrix(A,(env_pad[1],env_pad[2]),0) # padded occupancy grid
    K = zeros(Int,size(Ap))

    k = 0
    for i in 1:size(Ap,1)
        for j in 1:size(Ap,2)
            if Ap[i,j] == 0
                k += 1
                K[i,j] = k
            end
        end
    end
    return K
end

"""
    `construct_vtx_grid`

    Construct a vtx_grid from x_dim, y_dim, and a vtx_list.
"""
function construct_vtx_grid(x_dim::Int,y_dim::Int,vtxs::V) where {V<:Vector}
    vtx_grid = zeros(Int,x_dim,y_dim)
    for (k,vtx) in enumerate(vtxs)
        vtx_grid[vtx...] = k
    end
    vtx_grid
end

"""
    Returns a grid graph that represents a 2D environment with regularly spaced
    rectangular obstacles
"""
function initialize_grid_graph_from_vtx_grid(K::Matrix{Int})
    G = MetaGraph()
    for i in 1:size(K,1)
        for j in 1:size(K,2)
            if K[i,j] != 0
                add_vertex!(G)
                add_edge!(G,nv(G),nv(G))
            end
        end
    end

    for i in 1:size(K,1)
        for j in 1:size(K,2)
            if K[i,j] != 0
                if j < size(K,2)
                    add_edge!(G,K[i,j],K[i,j+1],Dict(:direction=>:NORTH))
                end
                if j > 1
                    add_edge!(G,K[i,j],K[i,j-1],Dict(:direction=>:SOUTH))
                end
                if i < size(K,1)
                    add_edge!(G,K[i,j],K[i+1,j],Dict(:direction=>:EAST))
                end
                if i > 1
                    add_edge!(G,K[i,j],K[i-1,j],Dict(:direction=>:WEST))
                end
            end
        end
    end
    G
end

"""
    Returns a grid graph that represents a 2D environment with regularly spaced
    rectangular obstacles
"""
function initialize_regular_grid_graph(;
    n_obstacles_x=2,
    n_obstacles_y=2,
    obs_width = [2;2],
    obs_offset = [1;1],
    env_pad = [1;1],
    env_offset = [1.0,1.0],
    env_scale = 2.0 # this is essentially the robot diameter
    )

    K = initialize_regular_vtx_grid(;
        n_obstacles_x=n_obstacles_x,
        n_obstacles_y=n_obstacles_y,
        obs_width=obs_width,
        obs_offset=obs_offset,
        env_pad=env_pad
        )

    graph = initialize_grid_graph_from_vtx_grid(K)
    for i in 1:size(K,1)
        for j in 1:size(K,2)
            if K[i,j] != 0
                set_props!(graph, K[i,j],
                    Dict(:x=>env_offset[1] + env_scale*(i-1),
                    :y=>env_offset[2] + env_scale*(j-1))
                    )
            end
        end
    end
    return graph
end

"""
    Returns a grid graph that represents a 2D environment with obstacles placed
    over specific vertices
"""
function initialize_grid_graph_with_obstacles(
    dims::Vector{Int},obstacles::Vector{Vector{Int}}=Vector{Vector{Int}}())
    vtx_grid = reshape(collect(1:dims[1]*dims[2]),dims[1],dims[2])
    for obs in obstacles
        vtx_grid[obs[1],obs[2]] = 0
    end
    discount = 0
    for j in 1:dims[2]
        for i in 1:dims[1]
            if vtx_grid[i,j] == 0
                discount += 1
            else
                vtx_grid[i,j] -= discount
            end
        end
    end
    G = MetaGraph(dims[1]*dims[2]-length(obstacles))
    for i in 1:dims[1]
        for j in 1:dims[2]
            if vtx_grid[i,j] != 0
                set_prop!(G,vtx_grid[i,j],:x,i)
                set_prop!(G,vtx_grid[i,j],:y,j)
                add_edge!(G,vtx_grid[i,j],vtx_grid[i,max(1,j-1)])
                add_edge!(G,vtx_grid[i,j],vtx_grid[i,min(dims[2],j+1)])
                add_edge!(G,vtx_grid[i,j],vtx_grid[max(1,i-1),j])
                add_edge!(G,vtx_grid[i,j],vtx_grid[min(dims[1],i+1),j])
            end
        end
    end
    G, vtx_grid
end

end
