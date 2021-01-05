let
    NODE_TYPE=Int
    ID_TYPE=Symbol
    my_tree = GraphUtils.CustomNTree{NODE_TYPE,ID_TYPE}()
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
    g = GraphUtils.CustomNEGraph{DiGraph,NODE_TYPE,EDGE_TYPE,ID_TYPE}()
    e = GraphUtils.CustomEdge(:ONE,:TWO,1+2)
    e2 = GraphUtils.CustomEdge(:TWO,:THREE,2+3)
    # EDGE_TYPE = Int
    # g = GraphUtils.NEGraph{DiGraph,NODE_TYPE,EDGE_TYPE,ID_TYPE}()
    # e = 3
    # e2 = 5
    isa(g,GraphUtils.AbstractCustomNGraph)
    add_node!(g,1,:ONE)
    add_node!(g,2,:TWO)
    add_node!(g,3,:THREE)
    @test add_edge!(g,:ONE,:TWO,e)
    @test !has_edge(g,:TWO,:ONE)
    @test add_edge!(g,:TWO,:THREE,e2)
    delete_node!(g,:THREE)
    @test !has_vertex(g,:THREE)
    @test !has_edge(g,:TWO,:THREE)
end
