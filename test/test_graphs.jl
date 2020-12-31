let
    my_tree = GraphUtils.CustomTree{Symbol,Symbol}()
    add_node!(my_tree,:ONE,:ONE)
    add_node!(my_tree,:TWO,:TWO)
    add_node!(my_tree,:THREE,:THREE)
    @test add_edge!(my_tree,:ONE,:TWO)
    # Vertex :TWO already has a parent--can't have another.
    @test !add_edge!(my_tree,:THREE,:TWO)
end
