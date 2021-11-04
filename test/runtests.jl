using CVRPLIB
using Test

@testset "CVRPLIB.jl" begin
    # Write your tests here.
    instances = [
        "E-n13-k4", "E-n101-k14", "X-n242-k48", "A-n80-k10", "F-n135-k7", 
        "M-n200-k17", "P-n50-k8", "CMT11", "tai150b", "Golden_10", 
        "Li_28", "X-n157-k13", "Brussels2", "Ghent2"
    ]
    for inst in instances
        cvrp, vrp_file, sol_file = readCVRP(inst)
        @testset "$inst" begin
            @info "Testing $inst..."
            @test isfile(vrp_file)
            @test isfile(sol_file)
            cvrp2 = readCVRPpath(vrp_file)
            @test size(cvrp2.weights) == size(cvrp.weights)
        end
    end

    wrong_instances = [ 
        "Daejeon", "E-n999-k999"
    ]
    for inst in wrong_instances
        @info "Testing broken: $inst"
        @test_broken readCVRP(inst)
    end


    @testset "write_CVRP" begin 
        @info "Testing write_CVRP"
        cvrp, vrp_file, sol_file = readCVRP("P-n16-k8")
        name, cvrp_file = write_cvrp(cvrp, dist=cvrp.weight_type)
        @test isfile(cvrp_file)
        delete_cvrp(cvrp_file)
        @test !isfile(cvrp_file)
    end
end
