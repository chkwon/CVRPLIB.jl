# CVRPLIB.jl

[![Build Status](https://github.com/chkwon/CVRPLIB.jl/workflows/CI/badge.svg?branch=master)](https://github.com/chkwon/CVRPLIB.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/chkwon/CVRPLIB.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/chkwon/CVRPLIB.jl)


This downloads and reads data files from [CVRPLIB](http://vrp.atd-lab.inf.puc-rio.br/index.php/en/).  This package is inspired by and built upon [TSPLIB.jl](https://github.com/matago/TSPLIB.jl)

## Installation 

```julia
] add CVRPLIB
```

## Usage

For example, to download the `X-n242-k48` instance:
```julia
cvrp, vrp_file, sol_file = readCVRPLIB("X-n242-k48")
```
It returns three values. `vrp_file` is the path for the downloaded `.vrp` file and `sol_file` is the path for the `.sol` file. 
`cvrp` is the main data of the following struct:

```julia
    mutable struct CVRP
        name            :: String
        dimension       :: Int
        weight_type     :: String
        weights         :: Matrix{Int}
        capacity        :: Int 
        distance        :: Float64
        service_time    :: Float64
        coordinates     :: Matrix{Float64}    
        demand          :: Vector{Int}
        depot           :: Int
        dummy           :: Int
        customers       :: Vector{Int}
    end
```
Note:
- `weights`, `capacity`, and `demand` are integer valued.
- `distance` is the distance limit for each route. If no duration constraint, it is set to `Inf`.
- `service_time` is the time for service at each customer node. It is set to `0.0`, when the service time is not presented.
- `dimension` is the number of nodes in the data, including the depot. 
- The index `depot` is usually `1`.


<!-- If `add_dummy=true` is provided, this package automatically adds a dummy depot node to the end of the list, i.e., `dimension + 1`. 
```julia
    cvrp, vrp_file, sol_file = readCVRPLIB("X-n242-k48", add_dummy=true)

    @assert size(cvrp.weights) == (cvrp.dimension + 1, cvrp.dimension +1)
    @assert size(cvrp.coordinates) == (cvrp.dimension + 1, 2)
    @assert length(cvrp.demands) == cvrp.dimension + 1
``` -->


# Related Data Packages
- [KnapsackLib.jl](https://github.com/rafaelmartinelli/Knapsacks.jl): Knapsack algorithms in Julia
- [FacilityLocationProblems.jl](https://github.com/rafaelmartinelli/FacilityLocationProblems.jl): Facility Location Problems Lib
- [AssignmentProblems.jl](https://github.com/rafaelmartinelli/AssignmentProblems.jl): Assignment Problems Lib
- [BPPLib.jl](https://github.com/rafaelmartinelli/BPPLib.jl): Bin Packing and Cutting Stock Problems Lib
- [CARPData.jl](https://github.com/rafaelmartinelli/CARPData.jl): Capacitated Arc Routing Problem Lib
- [MDVSP.jl](https://github.com/rafaelmartinelli/MDVSP.jl): Multi-Depot Vehicle Scheduling Problem Lib
- [TSPLIB.jl](https://github.com/matago/TSPLIB.jl): Traveling Salesman Problem Lib
