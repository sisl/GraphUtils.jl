# is_leaf_node
let
    G = DiGraph(2)
    add_edge!(G,1,2)
    @test is_leaf_node(G,1)
    @test !is_leaf_node(G,2)
end
