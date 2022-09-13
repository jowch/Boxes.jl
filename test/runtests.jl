using Boxes
using Test

@testset "Boxes" begin
    include("construction.jl")
    include("methods.jl")
    include("bbox.jl")
end
