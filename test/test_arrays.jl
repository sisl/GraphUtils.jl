let
    arr = ones(2,2)
    pad_matrix(arr,(2,2),0)
end
let
    a = [1.0,2,3]
    b = [-4.0,5,6]
    @test array_isapprox(cross(a,b),cross_product_operator(a)*b)
end
let
    n = 4
    for i in 1:n
        v = one_hot(n,i)
        @test v[i] == 1
        v = one_hot(i,n)
        @test v[i] == 1
        for j in 1:n
            if i != j
                @test v[j] == 0
            end
        end
    end
    @test_throws AssertionError one_hot(-1,3)
    @test_throws AssertionError one_hot(1,-3)
    @test_throws AssertionError one_hot(-1,-3)
end
