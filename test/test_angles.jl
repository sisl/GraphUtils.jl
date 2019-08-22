let
    θ = 1.0*π
    @test θ == wrap_to_pi(θ)
    @test θ == wrap_to_pi(-θ)

    θ = 20.0
    @test -π < wrap_to_pi(θ) <= π
end
