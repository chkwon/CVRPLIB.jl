# copied from https://github.com/matago/TSPLIB.jl

function readCVRP(name::AbstractString)
    vrp, sol = download_cvrp(name)
    raw = read(vrp, String)
    return _generateCVRP(raw), vrp, sol
end 

function readCVRPpath(path::AbstractString)
    raw = read(path, String)
    return _generateCVRP(raw)
end 

function _generateCVRP(raw::AbstractString)
    _dict = keyextract(raw, cvrp_keys)
    dimension = parse(Int, _dict["DIMENSION"])
    depot = parse.(Int, split(_dict["DEPOT_SECTION"]))[1]
    capacity = parse.(Int, _dict["CAPACITY"])
    dummy = dimension + 1
    
    if haskey(_dict, "NODE_COORD_SECTION")
        coords = parse.(Float64, split(_dict["NODE_COORD_SECTION"]))
        n_r = convert(Integer, length(coords) / dimension)
        coordinates = reshape(coords, (n_r, dimension))'[:, 2:end]
        coordinates = [coordinates; coordinates[depot, :]']
        weights = calc_weights(_dict["EDGE_WEIGHT_TYPE"], coordinates)    
    end

    if haskey(_dict, "DEMAND_SECTION")
        demand_data = parse.(Float64, split(_dict["DEMAND_SECTION"]))
        n_r = convert(Integer, length(demand_data) / dimension)
        demands_data = reshape(demand_data, (n_r, dimension))'[:, 2:end] 
        demands = dropdims(demands_data, dims=2)
        @show demands, typeof(demands), size(demands)
    end    

    return CVRP(
        _dict["NAME"],
        dimension,
        _dict["EDGE_WEIGHT_TYPE"],
        weights,
        capacity,
        coordinates,
        demands,
        depot,
        dummy
    )
end


function keyextract(raw::T, ks::Array{T}) where T<:AbstractString
    pq = PriorityQueue{T, Tuple{Integer, Integer}}()
    vals = Dict{T, T}()
    for k in ks
        idx = findfirst(k, raw)
        idx != nothing && enqueue!(pq, k, extrema(idx))
    end
    while length(pq) > 1
        s_key, s_pts = peek(pq)
        dequeue!(pq)
        f_key, f_pts = peek(pq)
        rng = (s_pts[2]+1):(f_pts[1]-1)
        vals[s_key] = strip(replace(raw[rng], ":" => ""))
    end
    return vals
end


function calc_weights(key::AbstractString, data::Matrix)
    w = @match key begin
        "EUC_2D"  => euclidian(data[:,1], data[:,2])
        "MAN_2D"  => manhattan(data[:,1], data[:,2])
        "MAX_2D"  => max_norm(data[:,1], data[:,2])
        "GEO"     => geo(data[:,1], data[:,2])
        "ATT"     => att_euclidian(data[:,1], data[:,2])
        "CEIL_2D" => ceil_euclidian(data[:,1], data[:,2])
        _         => error("Distance function type $key is not supported.")
    end

    return w
end


