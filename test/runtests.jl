using CVRPLIB
using Test

@testset "CVRPLIB.jl" begin
    # Write your tests here.
    instances = [
        "E-n13-k4", "E-n101-k14", "X-n242-k48", "A-n80-k10", "F-n135-k7", 
        "M-n200-k17", "P-n50-k8", "CMT11", "tai150b", "Golden_10", 
        "Li_28", "X-n157-k13"
        # , "Brussels2", "Ghent2" (out of memory in CI test for Windows)
    ]
    for inst in instances
        cvrp, vrp_file, sol_file = readCVRPLIB(inst)
        @testset "$inst" begin
            @test isfile(vrp_file)
            @test isfile(sol_file)
            cvrp2 = readCVRP(vrp_file)
            @test size(cvrp2.weights) == size(cvrp.weights)
        end
    end

    @testset "duration constraints" begin
        cvrp, _, _ = readCVRPLIB("CMT6")
        @test cvrp.distance == 200.0
        @test cvrp.service_time == 10.0

        cvrp, _, _ = readCVRPLIB("CMT7")
        @test cvrp.distance == 160.0
        @test cvrp.service_time == 10.0

    end


    @testset "add_dummy" begin 
        @testset "P-n50-k8" begin
            n = 50
            cvrp1, _, _ = readCVRPLIB("P-n50-k8")
            @test size(cvrp1.weights) == (n, n)
            @test cvrp1.dimension == n
            @test length(cvrp1.demand) == n
            @test size(cvrp1.coordinates) == (n, 2)
            @test cvrp1.dummy == cvrp1.depot

            cvrp2, _, _ = readCVRPLIB("P-n50-k8", add_dummy=true)
            @test size(cvrp2.weights) == (n + 1, n + 1)
            @test cvrp2.dimension == n
            @test length(cvrp2.demand) == n + 1
            @test size(cvrp2.coordinates) == (n + 1, 2)
            @test cvrp2.dummy == n + 1
        end

        @testset "E-n13-k4" begin
            n = 13
            cvrp1, _, _ = readCVRPLIB("E-n13-k4")
            @test size(cvrp1.weights) == (n, n)
            @test cvrp1.dimension == n
            @test length(cvrp1.demand) == n
            @test cvrp1.dummy == cvrp1.depot

            cvrp2, _, _ = readCVRPLIB("E-n13-k4", add_dummy=true)
            @test size(cvrp2.weights) == (n + 1, n + 1)
            @test cvrp2.dimension == n
            @test length(cvrp2.demand) == n + 1
            @test cvrp2.dummy == n + 1
        end
    end
    

    wrong_instances = [ 
        "Daejeon", "E-n999-k999"
    ]
    for inst in wrong_instances
        @test_broken readCVRPLIB(inst)
    end

    write_instances = [
        "P-n16-k8", "E-n13-k4", "CMT6", "CMT7"
    ]
    @testset "write_CVRP" begin 
        for inst in write_instances
            @testset "$inst" begin
                cvrp, vrp_file, sol_file = readCVRPLIB(inst)
                name, cvrp_file = write_cvrp(cvrp)
                @test isfile(cvrp_file)

                cvrp2 = readCVRP(cvrp_file)
                @test cvrp.dimension == cvrp2.dimension
                @test cvrp.capacity == cvrp2.capacity 
                @test cvrp.distance == cvrp2.distance
                @test cvrp.service_time == cvrp2.service_time

                delete_cvrp(cvrp_file)
                @test !isfile(cvrp_file)
            end
        end
    end
    @testset "write_CVRP: add_dummy" begin 
        for inst in write_instances
            @testset "$inst" begin
                cvrp, vrp_file, sol_file = readCVRPLIB(inst, add_dummy=true)
                name, cvrp_file = write_cvrp(cvrp)
                @test isfile(cvrp_file)

                cvrp2 = readCVRP(cvrp_file)
                @test cvrp.dimension == cvrp2.dimension
                @test cvrp.capacity == cvrp2.capacity 
                @test cvrp.distance == cvrp2.distance
                @test cvrp.service_time == cvrp2.service_time

                delete_cvrp(cvrp_file)
                @test !isfile(cvrp_file)
            end
        end
    end    
end
