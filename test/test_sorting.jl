# topological_sort
let
    # simple graph
    G = DiGraph(4)
    add_edge!(G,1,3)
    add_edge!(G,1,4)
    add_edge!(G,2,3)
    add_edge!(G,3,4)
    ordering = topological_sort(G)
    @test ordering == [1,2,3,4]
end
let
    # disjoint graph
    G = DiGraph(4)
    add_edge!(G,1,2)
    add_edge!(G,3,4)
    ordering = topological_sort(G)
    @test length(ordering) == nv(G)
    @test findfirst(ordering .== 1) < findfirst(ordering .== 2)
    @test findfirst(ordering .== 3) < findfirst(ordering .== 4)
end
let
    # cyclic graph (should throw error)
    G = DiGraph(3)
    add_edge!(G,1,2)
    add_edge!(G,2,3)
    add_edge!(G,3,1)
    @test_throws AssertionError topological_sort(G)
end
# insert_to_sorted_array
let
    array = [1.0,2.0,3.0,4.0,5.0]
    array = insert_to_sorted_array!(array, 3.5)
    @test(array[4] == 3.5)
    array = insert_to_sorted_array!(array, 0.5)
    @test(array[1] == 0.5)
    array = insert_to_sorted_array!(array, 5.5)
    @test(array[end] == 5.5)
end
