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
        end
    end

    wrong_instances = [ 
        "Daejeon", "E-n999-k999"
    ]
    for inst in wrong_instances
        @test_broken readCVRP(inst)
    end

end
