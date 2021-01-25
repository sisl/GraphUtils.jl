# test abstract trees
let
    ID_TYPE = VtxID
    EL_TYPE = Int
    a = GraphUtils.TreeNode{EL_TYPE,ID_TYPE}(1)
    b = GraphUtils.TreeNode{EL_TYPE,ID_TYPE}(2)
    c = GraphUtils.TreeNode{EL_TYPE,ID_TYPE}(3)
    GraphUtils._id_type(a)
    set_parent!(b,a)
    @test get_parent(a) === a
    @test get_parent(b) === a
    @test haskey(get_children(a),node_id(b))
    @test validate_tree(a)
    @test validate_tree(b)
    # make tree cyclic and check for error in validation 
    set_parent!(c,b)
    set_parent!(a,c)
    @test_throws ErrorException validate_tree(b)
end