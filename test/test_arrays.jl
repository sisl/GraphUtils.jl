let
    arr = ones(2,2)
    pad_matrix(arr,(2,2),0)
end
let
    a = [1.0,2,3]
    b = [-4.0,5,6]
    @test array_isapprox(cross(a,b),cross_product_operator(a)*b)
end
