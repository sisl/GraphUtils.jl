let
    K = initialize_regular_vtx_grid();
    G = initialize_regular_grid_graph()
    @test nv(G) == sum(K .!= 0)
    initialize_grid_graph_with_obstacles([10,10],[[1,2],[3,4]])
end
