# Core Types

## Graph
```@docs
AbstractCustomNGraph
get_graph
get_vtx_ids
get_vtx_map
get_nodes
node_val
edge_val
edge_source
edge_target
replace_node!
add_node!
make_node
make_edge
add_child!
add_parent!
rem_node!
is_terminal_node
get_all_root_nodes
get_all_terminal_nodes
get_dist_matrix
topological_sort
```


## Tree
```@docs
AbstractCustomNTree
AbstractTreeNode
validate_tree
validate_embedded_tree
```

## Factory World
```@docs
construct_vtx_map
construct_edge_cache
construct_expanded_zones
validate_expanded_zones
SparseDistanceMatrix
remap_idx
recompute_cached_distances!
config_index_to_tuple
RemappedDistanceMatrix
GridFactoryEnvironment
construct_regular_factory_world
construct_factory_env_from_vtx_grid
construct_factory_env_from_indicator_grid
```