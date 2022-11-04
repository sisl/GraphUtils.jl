# Core Types

## Graph
```@docs
AbstractCustomNGraph
AbstractCustomNDiGraph
get_graph
get_vtx_ids
get_vtx_map
get_nodes
get_vtx
get_vtx_id
get_node
get_parent
get_edge
replace_edge!
node_val
edge_val
edge_source
edge_target
set_vtx_map!
insert_to_vtx_map!
replace_node!
add_node!
make_node
make_edge
add_child!
add_parent!
rem_node!
rem_nodes!
```


## Tree
```@docs
AbstractCustomNTree
AbstractCustomNETree
AbstractCustomTree
AbstractTreeNode
get_parent
get_children
rem_parent!
set_parent!
has_child
has_parent
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
get_x_dim
get_y_dim
get_cell_width
get_transition_time
get_vtxs
get_pickup_zones
get_dropoff_zones
get_obstacles
get_pickup_vtxs
get_dropoff_vtxs
get_obstacle_vtxs
get_num_free_vtxs
get_free_zones
```