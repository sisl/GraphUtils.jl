module GraphUtils

using LightGraphs, MetaGraphs
using Reexport

# TODO break GraphUtils up into a set of reusable Utils packages

include("sorting.jl")
include("connectivity.jl")
include("angles.jl")
include("arrays.jl")
include("construction.jl")
include("cubic_splines.jl")

@reexport using GraphUtils.Sorting
@reexport using GraphUtils.Connectivity
@reexport using GraphUtils.Angles
@reexport using GraphUtils.Arrays
@reexport using GraphUtils.Construction
@reexport using GraphUtils.CubicSplines

end # module
