[![CI](https://github.com/sisl/GraphUtils.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/sisl/GraphUtils.jl/actions/workflows/ci.yml)
[![pages-build-deployment](https://github.com/sisl/GraphUtils.jl/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/sisl/GraphUtils.jl/actions/workflows/pages/pages-build-deployment)

This a repository created as a list of helper functions for the main repository TaskGraphs.jl. Please install this package first before running the GraphUtils package.
# GraphUtils.jl
## Installation:
```julia
git add https://github.com/sisl/GraphUtils.jl
```


## Quick Start
To run a simple use case of topological sort.
```julia
using GraphUtils
using Graphs
G = DiGraph(4);
add_edge!(G,1,2);
add_edge!(G,1,4);
add_edge!(G,2,3);
add_edge!(G,3,4);
ordering = GraphUtils.topological_sort(G);
ordering == [1,2,3,4]

```
