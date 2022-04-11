# copied from https://github.com/matago/TSPLIB.jl

function readCVRPLIB(name::AbstractString; add_dummy=false)
    vrp, sol = download_cvrp(name)
    raw = read(vrp, String)
    return _generateCVRP(raw; add_dummy=add_dummy), vrp, sol
end 

function readCVRP(path::AbstractString; add_dummy=false)
    raw = read(path, String)
    return _generateCVRP(raw; add_dummy=add_dummy)
end 

function _generateCVRP(raw::AbstractString; add_dummy=false)
    _dict = TSPLIB.keyextract(raw, cvrp_keys)

    name = _dict["NAME"]
    dimension = parse(Int, _dict["DIMENSION"])
    weight_type = _dict["EDGE_WEIGHT_TYPE"]

    if haskey(_dict, "DEPOT_SECTION")
        depot = parse.(Int, split(_dict["DEPOT_SECTION"]))[1]
    else
        depot = 1
        @warn "$name does not have 'DEPOT_SECTION'. Depot is set to node 1."
    end
    capacity = parse.(Int, _dict["CAPACITY"])

    check_dimension = add_dummy ? dimension + 1 : dimension
    dummy = add_dummy ? dimension + 1 : depot

    customers = setdiff(1:(dimension+1), [depot, dummy])
    
    if weight_type == "EXPLICIT" && haskey(_dict, "EDGE_WEIGHT_SECTION")
        explicits = parse.(Int, split(_dict["EDGE_WEIGHT_SECTION"]))
        weights = explicit_weights(_dict["EDGE_WEIGHT_FORMAT"], explicits)
        #Push display data to nodes if possible
        if haskey(_dict,"DISPLAY_DATA_SECTION")
            coords = parse.(Float64, split(_dict["DISPLAY_DATA_SECTION"]))
            n_r = convert(Integer,length(coords)/dimension)
            nodes = reshape(coords,(n_r,dimension))'[:,2:end]
            dxp = true
        else
            nodes = zeros(dimension, 2)
        end

        # Expanding weights for dummy depot 
        if add_dummy
            weights = [weights weights[:, depot]]
            weights = [weights; weights[depot, :]']
        end

        # No coordinate information 
        coordinates = Matrix{Float64}(undef, 0, 0)

    elseif haskey(_dict, "NODE_COORD_SECTION")
        coords = parse.(Float64, split(_dict["NODE_COORD_SECTION"]))
        n_r = convert(Integer, length(coords) / dimension)
        coordinates = reshape(coords, (n_r, dimension))'[:, 2:end]
        
        # copy depot and create a dummy
        if add_dummy
            coordinates = [coordinates; coordinates[depot, :]']
        end

        weights = Int.(TSPLIB.calc_weights(_dict["EDGE_WEIGHT_TYPE"], coordinates))
        @assert size(coordinates) == (check_dimension, 2)
    end

    @assert size(weights) == (check_dimension, check_dimension)

    distance_limit = Inf
    if haskey(_dict, "DISTANCE")
        distance_limit = parse(Float64, _dict["DISTANCE"])
    end

    service_time = 0.0
    if haskey(_dict, "SERVICE_TIME")
        service_time = parse(Float64, _dict["SERVICE_TIME"])
    end


    if haskey(_dict, "DEMAND_SECTION")
        demand_data = parse.(Int, split(_dict["DEMAND_SECTION"]))
        n_r = convert(Integer, length(demand_data) / dimension)
        demands_data = reshape(demand_data, (n_r, dimension))'[:, 2:end] 
        demands = dropdims(demands_data, dims=2)

        # copy depot and create a dummy
        if add_dummy
            demands = [demands; demands[depot]]
        end
        
        @assert length(demands) == check_dimension
    end    


    return CVRP(
        _dict["NAME"],
        dimension,
        _dict["EDGE_WEIGHT_TYPE"],
        weights,
        capacity,
        distance_limit,
        service_time,
        coordinates,
        demands,
        depot,
        dummy,
        customers
    )
end




function explicit_weights(key::AbstractString, data::Vector{Int})
    w = @match key begin
      "UPPER_DIAG_ROW"  => TSPLIB.vec2UDTbyRow(data)
      "LOWER_DIAG_ROW"  => TSPLIB.vec2LDTbyRow(data)
      "UPPER_DIAG_COL"  => TSPLIB.vec2UDTbyCol(data)
      "LOWER_DIAG_COL"  => TSPLIB.vec2LDTbyCol(data)
      "UPPER_ROW"       => TSPLIB.vec2UTbyRow(data)
      "LOWER_ROW"       => vec2LTbyRow(data)
      "FULL_MATRIX"     => TSPLIB.vec2FMbyRow(data)
    end
    if !in(key, ["FULL_MATRIX"])
      w .+= w'
    end
    return w
end

function vec2LTbyRow(v::AbstractVector{T}, z::T=zero(T)) where T
    n = length(v)
    s = round(Integer,((sqrt(8n+1)-1)/2)+1)
    (s*(s+1)/2)-s == n || error("vec2LTbyRow: length of vector is not triangular")
    k=0
    [i<j ? (k+=1; v[k]) : z for i=1:s, j=1:s]'
end

  
  