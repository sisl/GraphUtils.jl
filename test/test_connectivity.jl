# is_leaf_node
let
    G = DiGraph(2)
    add_edge!(G,1,2)
    @test is_leaf_node(G,1)
    @test !is_leaf_node(G,2)
end
let
    G = DiGraph(2)
    add_edge!(G,1,2)
    D = get_dist_matrix(G)
    @test D == [0 1; 1 0] 
end
