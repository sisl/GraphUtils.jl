# is_root_node
let
    G = DiGraph(2)
    add_edge!(G,1,2)
    @test is_root_node(G,1)
    @test !is_terminal_node(G,1)
    @test !is_root_node(G,2)
    @test is_terminal_node(G,2)
    @test get_all_root_nodes(G) == Set{Int}(2)
end
let
    G = Graph(2)
    add_edge!(G,1,2)
    D = get_dist_matrix(G)
    @test D == [0 1; 1 0]
end
