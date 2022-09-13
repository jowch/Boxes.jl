"""
    AbstractBox

An abstract representation for boxes.
"""
abstract type AbstractBox end

"""
	width(box)

Computes the width of the given `box`.
"""
function width end

"""
	height(box)

Computes the height of the given `box`.
"""
function height end

"""
    center(box)

Finds the coordinates of the center of the given `box`.
"""
function center end

"""
    topleft

Finds the top-left corner of a given `box`.
"""
function topleft end

"""
    topright

Finds the top-right corner of a given `box`.
"""
function topright end

"""
    bottomleft

Finds the bottom-left corner of a given `box`.
"""
function bottomleft end

"""
    bottomright

Finds the bottom-right corner of a given `box`.
"""
function bottomright end

"""
	flip(box)

Returns a copy of a box where the point coordinates are reversed: `(x, y) -> (y, x)`.
"""
function flip end


# Extend Base methods for convenience
(==)(a::AbstractBox, b::AbstractBox) =
    topleft(a) == topleft(b) && bottomleft(a) == bottomleft(b)

convert(::Type{B}, b::B) where {B <: AbstractBox} = b

function to_indices(
    A::AbstractArray{T, N},
    inds,
    I::Tuple{AbstractBox, Vararg{Any}},
) where {T, N}
    if N > 1
        box = first(I)
        (x, y), w, h = topleft(box), width(box), height(box)
        to_indices(A, inds, (x:(x + w), y:(y + h), Base.tail(I)...))
    else
        error("Array does not have enough dimensions to index with a Box.")
    end
end

function center(box::AbstractBox)
    (x₁, y₁), (x₂, y₂) = topleft(box), bottomright(box)
    (x₁ + x₂) / 2, (y₁ + y₂) / 2
end

"""
	corners(box)

Gets the corners of the given `box` as an array of points in the following order:
  - [`topleft`](@ref)
  - [`topright`](@ref)
  - [`bottomright`](@ref)
  - [`bottomleft`](@ref)
"""
corners(box::AbstractBox) = [topleft(box), topright(box), bottomright(box), bottomleft(box)]

"""
	area(box)

Computes the area of a box.

See also [`width`](@ref) and [`height`](@ref).

# Examples
```julia-repl
julia> box = Box(0, 0, 2, 2)
Box(0, 0, 2, 2)

julia> area(box)
4
```
"""
area(box::AbstractBox) = width(box) * height(box)

"""
	contains(a, b)

Is a is contained within b
"""
function contains(a::AbstractBox, b::AbstractBox)
    (ax₁, ay₁), (ax₂, ay₂) = topleft(a), bottomright(a)
    (bx₁, by₁), (bx₂, by₂) = topleft(b), bottomright(b)

    bx₁ <= ax₁ && by₁ <= ay₁ && ax₂ <= bx₂ && ay₂ <= by₂
end


"""
	iou(a, b)

Computes the intersection over union (IoU) of two boxes. This is a measure of
how much overlap there are between two boxes.
"""
function iou(a::AbstractBox, b::AbstractBox)
    (ax₁, ay₁), (ax₂, ay₂) = topleft(a), bottomright(a)
    (bx₁, by₁), (bx₂, by₂) = topleft(b), bottomright(b)

    ix₁, iy₁ = max(ax₁, bx₁), max(ay₁, by₁)
    ix₂, iy₂ = min(ax₂, bx₂), min(ay₂, by₂)

    if (ix₂ < ix₁) || (iy₂ < iy₁)
        return 0.0
    end

    area_inter = max(0, ix₂ - ix₁) * max(0, iy₂ - iy₁)

    area_inter / (area(a) + area(b) - area_inter)
end

"""
	distance(a, b)

Computes the euclidean distance between the centers of two boxes. 
"""
distance(a::AbstractBox, b::AbstractBox) = norm(center(a) .- center(b))
