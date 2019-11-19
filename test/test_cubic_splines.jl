let
    n = 10
    t = collect(0:(1/10):1)
    x = sin.(t)
    spline = CubicSpline(t,x)
    interpolate(spline, 0.41)
    deriv(spline, 0.41)
    hess(spline, 0.41)
end
let
    n = 10
    t = collect(0:(1/10):1)
    x = sin.(t)
    y = sin.(t)
    X = hcat(x,y)
    spline = ParametricSpline(t,X)
    interpolate(spline, 0.41)
    deriv(spline, 0.41)
    hess(spline, 0.41)
end
