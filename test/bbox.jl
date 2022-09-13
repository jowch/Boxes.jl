@testset "Bounding Boxes" begin
    @testset "Basic" begin
        indices = [(0, 0), (2, 2)]
        expected = XYXYBox(0, 0, 2, 2)

        @test boundingbox(CartesianIndex.(indices)...) == expected
        @test boundingbox(indices...) == expected

        @test boundingbox(XYXYBox, indices...) == expected
        @test typeof(boundingbox(XYXYBox, indices...)) <: XYXYBox

        @test boundingbox(CornerBox, indices...) == convert(CornerBox, expected)
        @test typeof(boundingbox(CornerBox, indices...)) <: CornerBox
    end

    @testset "Mask" begin
        box = XYXYBox(1, 1, 3, 3)
        mask = let m = falses(5, 5)
            m[box] .= true
        end

        @test boundingbox(mask) == box
        @test typeof(boundingbox(CornerBox, mask)) <: CornerBox
    end

    @testset "Boxes" begin
        a = CornerBox(0, 0, 2, 2)
        b = XYXYBox(1, 1, 3, 3)
        c = XYXYBox(0, 0, 3, 3)

        @test boundingbox(a, b) == c
        @test boundingbox(CornerBox, a, b) == c
        @test typeof(boundingbox(CornerBox, a, b)) <: CornerBox

        @test boundingbox(a, b, c) == c
    end
end