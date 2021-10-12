


module CVRPLIB 

using DataStructures
using Match
using Downloads
import TSPLIB

    mutable struct CVRP
        name        :: AbstractString
        dimension   :: Integer
        weight_type :: AbstractString
        weights     :: Matrix
        capacity    :: Integer 
        coordinates :: Matrix    
        demand      :: Vector
        depot       :: Integer
        dummy       :: Integer
        customers   :: Vector
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
    include("download.jl")


    export readCVRP, readCVRPpath, CVRP

end

