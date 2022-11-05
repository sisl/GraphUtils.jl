[![CI](https://github.com/sisl/GraphUtils.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/sisl/GraphUtils.jl/actions/workflows/ci.yml)
[![pages-build-deployment](https://github.com/sisl/GraphUtils.jl/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/sisl/GraphUtils.jl/actions/workflows/pages/pages-build-deployment)

Welcome to the GraphUtils.jl documentation. The purpose of this project is to provide an example package structure which can be easily copied and modified.
Please install this package first before running the TaskGraphs.jl package.
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
