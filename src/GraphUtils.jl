module GraphUtils

using LightGraphs, MetaGraphs
using Reexport

# TODO break GraphUtils up into a set of reusable Utils packages

include("sorting.jl")
include("connectivity.jl")
include("angles.jl")

@reexport using GraphUtils.Sorting
@reexport using GraphUtils.Connectivity
@reexport using GraphUtils.Angles

end # module
