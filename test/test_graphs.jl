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
let
    NODE_TYPE = Int
    ID_TYPE = Symbol
    EDGE_TYPE = GraphUtils.CustomEdge{Int,ID_TYPE}
    g = GraphUtils.DoubleCustomGraph{DiGraph,NODE_TYPE,EDGE_TYPE,ID_TYPE}()
    add_node!(g,1,:ONE)
    add_node!(g,2,:TWO)
    add_node!(g,3,:THREE)
    e = GraphUtils.CustomEdge(:ONE,:TWO,1+2)
    add_edge!(g,e,:ONE,:TWO)
    @test has_edge(g,e)
    @test !has_edge(g,:TWO,:ONE)
    e2 = GraphUtils.CustomEdge(:TWO,:THREE,2+3)
    add_edge!(g,e2,:TWO,:THREE)
    @test has_edge(g,e2)
    delete_node!(g,:THREE)
    @test !has_vertex(g,:THREE)
    @test !has_edge(g,e2)
end
