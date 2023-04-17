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

    # tests for functions that are defined for all boxes
    @testset "Abstract Methods" begin
        # width and height
        @test width(XYXYBox(0, 0, 2, 2)) == 2
        @test height(XYXYBox(0, 0, 2, 2)) == 2
        
        # centers
        @test center(XYXYBox(0, 0, 2, 2)) == (1, 1)
        @test center(XYXYBox(0, 0, 3, 3)) == (1.5, 1.5)

        # corners
        @test topleft(XYXYBox(0, 0, 2, 2)) == (0, 0)
        @test topright(XYXYBox(0, 0, 2, 2)) == (2, 0)
        @test bottomleft(XYXYBox(0, 0, 2, 2)) == (0, 2)
        @test bottomright(XYXYBox(0, 0, 2, 2)) == (2, 2)
        @test corners(XYXYBox(0, 0, 2, 2)) == [(0, 0), (2, 0), (2, 2), (0, 2)]

        # flip
        @test flip(XYXYBox(0, 0, 2, 2)) == XYXYBox(0, 0, 2, 2)
        @test flip(XYXYBox(0, 1, 2, 1)) == XYXYBox(1, 0, 1, 2)

        # area
        @test area(XYXYBox(0, 0, 2, 2)) == 4

        # indices
        # @test to_indices(ones(3, 3), (), XYXYBox(0, 0, 2, 2)) == CartesianIndices((0:2, 0:2))
        
        # contains
        @test contains(XYXYBox(1, 1, 2, 2), XYXYBox(0, 0, 2, 2))
        @test contains(XYXYBox(0, 0, 1, 1), XYXYBox(0, 0, 2, 2))
        @test contains(XYXYBox(0, 0, 2, 2), XYXYBox(0, 0, 2, 2))
        @test !contains(XYXYBox(2, 2, 3, 3), XYXYBox(0, 0, 2, 2))
        @test !contains(XYXYBox(1, 1, 3, 3), XYXYBox(0, 0, 2, 2))

        # iou
        @test iou(XYXYBox(0, 0, 2, 2), XYXYBox(1, 1, 3, 3)) == 1/(8-1)
        @test iou(XYXYBox(0, 0, 2, 2), XYXYBox(2, 2, 4, 4)) == 0
        @test iou(XYXYBox(0, 0, 2, 2), XYXYBox(0, 0, 2, 2)) == 1
        @test iou(XYXYBox(0, 0, 2, 2), XYXYBox(0, 0, 4, 4)) == 4/16

        # distance
        @test distance(XYXYBox(0, 0, 2, 2), XYXYBox(1, 1, 3, 3)) == √2
        @test distance(XYXYBox(0, 0, 2, 2), XYXYBox(2, 2, 4, 4)) == 2√2
        @test distance(XYXYBox(0, 0, 2, 2), XYXYBox(0, 0, 4, 4)) == √2
        @test distance(XYXYBox(0, 0, 2, 2), XYXYBox(0, 0, 2, 2)) == 0
    end
end