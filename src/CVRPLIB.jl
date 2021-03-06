


module CVRPLIB 

using DataStructures
using Match
using Downloads
using Random
using DelimitedFiles
import TSPLIB

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

    const cvrp_keys = [
        "NAME",
        "TYPE",
        "COMMENT",
        "DIMENSION",
        "EDGE_WEIGHT_TYPE",
        "EDGE_WEIGHT_FORMAT",
        "EDGE_DATA_FORMAT",
        "CAPACITY",
        "DISTANCE",
        "SERVICE_TIME",
        "NODE_COORD_TYPE",
        "DISPLAY_DATA_TYPE",
        "NODE_COORD_SECTION",
        "DEPOT_SECTION",
        "DEMAND_SECTION",
        "EDGE_DATA_SECTION",
        "FIXED_EDGES_SECTION",
        "DISPLAY_DATA_SECTION",
        "TOUR_SECTION",
        "EDGE_WEIGHT_SECTION",
        "EOF"
    ]


    include("reader.jl")
    include("writer.jl")
    include("download.jl")


    export readCVRP, readCVRPLIB, CVRP, write_cvrp, delete_cvrp

end

