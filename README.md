# CVRPLIB.jl

[![Build Status](https://github.com/chkwon/CVRPLIB.jl/workflows/CI/badge.svg?branch=master)](https://github.com/chkwon/CVRPLIB.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/chkwon/CVRPLIB.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/chkwon/CVRPLIB.jl)


This downloads and reads data files from [CVRPLIB](http://vrp.atd-lab.inf.puc-rio.br/index.php/en/).  This package is inspired by and built upon [TSPLIB.jl](https://github.com/matago/TSPLIB.jl)

## Installation 

```julia
] add https://github.com/chkwon/CVRPLIB.jl
```

## Usage

For example, to download the `X-n242-k48` instance:
```julia
cvrp, vrp_file, sol_file = readCVRP("X-n242-k48")
```
It returns three values. `vrp_file` is the path for the downloaded `.vrp` file and `sol_file` is the path for the `.sol` file. 
`cvrp` is the main data of the following struct:

```julia
struct CVRP
    name        :: AbstractString
    dimension   :: Int
    weight_type :: AbstractString
    weights     :: AbstractMatrix{Int}
    capacity    :: Int 
    coordinates :: AbstractMatrix{Float64}    
    demand      :: Vector{Int}
    depot       :: Int
    dummy       :: Int
    customers   :: Vector{Int}
end
```

Note:
- `weights`, `capacity`, and `demand` are integer-valued.
- `dimension` is the number of nodes in the data, including the depot. 
- The index `depot` is usually `1`, and this package automatically adds a dummy depot node to the end of the list, i.e., `dimension + 1`. Therefore, we have `size(weights) = (dimension + 1, dimension +1)` and `size(coordinates) = (dimension + 1, 2)`.

```julia
    @assert size(weights) == (dimension + 1, dimension +1)
    @assert size(coordinates) == (dimension + 1, 2)
    @assert length(demands) == dimension + 1
```
