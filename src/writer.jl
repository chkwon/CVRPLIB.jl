function delete_cvrp(filepath)
    rm(filepath)
end

function write_cvrp(cvrp::CVRPLIB.CVRP; dist="EUC_2D")
    if isnothing(cvrp.coordinates) 
        error("CVRPLIB: Explicit weights without coordinates are not supported yet.")
    end

    x = cvrp.coordinates[:, 1]
    y = cvrp.coordinates[:, 2]
    demand = cvrp.demand
    depot = cvrp.depot
    capacity = cvrp.capacity

    n_nodes = cvrp.dimension

    name = randstring(10)
    filepath = joinpath(pwd(), name * ".vrp")

    open(filepath, "w") do io
        write(io, "NAME : $(name)\n")
        write(io, "COMMENT : Generated by BranchPriceCutCVRP.jl\n")
        write(io, "TYPE : CVRP\n")
        write(io, "DIMENSION : $(n_nodes)\n")
        write(io, "EDGE_WEIGHT_TYPE : $(dist)\n")
        write(io, "CAPACITY : $(capacity)\n")
        write(io, "NODE_COORD_SECTION\n")
        for i in 1:n_nodes
            write(io, "$i $(x[i]) $(y[i])\n")
        end
        write(io, "DEMAND_SECTION\n")
        for i in 1:n_nodes
            write(io, "$i $(demand[i])\n")
        end
        write(io, "DEPOT_SECTION\n")
        write(io, "$(depot)\n")
        write(io, "-1\n")
        write(io, "EOF\n")
    end

    return name, filepath
end