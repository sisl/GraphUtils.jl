# module Angles

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


"""
    intersections_between_circles(v1,v2,r1,r2)
"""
function intersections_between_circles(v1,v2,r1,r2)
    d = norm(v1-v2)
    if d > r1+r2
        return nothing
    elseif d < 1e-4 # almost collocated
        return nothing
    elseif d + r1 < r2 || d + r2 < r1 # completely contained
        return nothing
    else
        x1,y1 = v1[1], v1[2]
        x2,y2 = v2[1], v2[2]
        l = (r1^2 - r2^2 + d^2)/(2*d)
        h = sqrt(r1^2-l^2)
        v0 = (l/d) * [(x2-x1), (y2-y1)] .+ v1
        dv = (h/d) * [(y2-y1), -(x2-x1)]

        return v0 .+ dv, v0 .- dv
    end
end

function nearest_points_between_circles(v1,v2,r1,r2)
    d = norm(v1-v2)
    vec = v2 .- v1
    if d > r1+r2
        return v1 + normalize(vec) * r1,  v2 - normalize(vec) * r2
    elseif d + r1 < r2 # circle 1 contained in circle 2 
        return v1 - normalize(vec) * r1,  v2 - normalize(vec) * r2
    elseif d + r2 < r1 # circle 2 contained in circle 1
        return v1 + normalize(vec) * r1,  v2 + normalize(vec) * r2
    elseif d < 1e-4 # almost collocated
        return nothing
    else
        return intersections_between_circles(v1,v2,r1,r2)
    end
end