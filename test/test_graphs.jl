let
    NODE_TYPE=Int
    ID_TYPE=Symbol
    my_tree = GraphUtils.CustomTree{NODE_TYPE,ID_TYPE}()
    add_node!(my_tree,1,:ONE)
    add_node!(my_tree,2,:TWO)
    add_node!(my_tree,3,:THREE)
    @test add_edge!(my_tree,:ONE,:TWO)
    # Vertex :TWO already has a parent--can't have another.
    @test !add_edge!(my_tree,:THREE,:TWO)
    add_child!(my_tree,:THREE,4,:FOUR)
    @test has_edge(my_tree,:THREE,:FOUR)
end
