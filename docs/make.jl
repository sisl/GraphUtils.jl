using Documenter, GraphUtils

#
include("src/makeplots.jl")

# This function builds the documentation
makedocs(
    modules   = [GraphUtils],  
    format    = Documenter.HTML(
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://kylejbrown17.github.io/GraphUtils.jl",
        assets=String[],
    ),
    sitename  = "GraphUtils.jl",
    authors   = "Duncan Eddy",
    pages     = [
        "Home" => "index.md",
        "Getting Started" => "getting_started.md",
        "Core Types and Methods" => "library.md",
        "API Reference" => "reference.md",
    ],
)

# Generate plots
# Note: Must be called after makedocs so the build folder are created
#makeplots()

deploydocs(
    repo = "github.com/sisl/GraphUtils.jl",
    devbranch = "master",
    devurl = "latest",
    #deps = makeplots,
)