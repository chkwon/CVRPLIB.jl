using CVRPLIB
using Test

@testset "CVRPLIB.jl" begin
    # Write your tests here.
    cvrp, vrp_file, sol_file = readCVRP("X-n242-k48")
    @test isfile(vrp_file)
    @test isfile(sol_file)
end
