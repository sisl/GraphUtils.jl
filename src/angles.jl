module Angles

export
    wrap_to_pi

"""
    `wrap_to_pi(θ₀)`

    wraps the angle θ₀ to a value in (-π,π]
"""
function wrap_to_pi(θ₀)
    θ = θ₀
    while θ > π
        θ = θ - 2π
    end
    while θ <= -π
        θ += 2π
    end
    return θ
end

end
