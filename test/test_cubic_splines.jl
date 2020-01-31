let
    n = 5
    tf = 5
    t = collect(0:(tf/n):tf)
    f(t) = sin.(t)
    fdot(t) = cos.(t)

    x = f(t)
    spline = CubicSpline(t,x)
    interpolate(spline, t[1])
    deriv(spline, t[1])
    hess(spline, t[1])
    interpolate(spline, [t[1], t[end]])
    deriv(spline, [t[1], t[end]])
    hess(spline, [t[1], t[end]])

    dt = 1.0
    @test extrapolate(spline, t[end]+dt, 0) == interpolate(spline, t[end])
    @test extrapolate(spline, t[end]+dt, 1) == interpolate(spline, t[end]) + deriv(spline, t[end])*dt
    @test extrapolate(spline, t[1]-dt, 0) == interpolate(spline, t[1])
    @test extrapolate(spline, t[1]-dt, 1) == interpolate(spline, t[1]) - deriv(spline, t[1])*dt

    xdot = fdot(t)
    spline2 = CubicSpline(t,x,xdot) # prescribe knot tangents directly

    # plt = plot(t_vec, interpolate(spline, t_vec))
    # plot!(plt, t_vec, interpolate(spline2, t_vec))
    # plot!(plt, t_vec, f(t_vec))
    # plot!(plt, t, x, seriestype=:scatter)
end
let
    ParametricSpline()
end
let
    n = 10
    t = collect(0:(1/10):1)
    x = sin.(t)
    y = sin.(t)
    X = hcat(x,y)
    spline = ParametricSpline(t,X)
    interpolate(spline, t[1])
    deriv(spline, t[1])
    hess(spline, t[1])
    interpolate(spline, [t[1], t[end]])
    deriv(spline, [t[1], t[end]])
    hess(spline, [t[1], t[end]])
end
