"""
	boundingbox([T,] indices::CartesianIndex...; pad = 0)
	boundingbox([T,] indices::NTuple{2,<:Integer}...; pad = 0)

Computes the circumscribing bounding box for the given `indices`. We can
optionally add (or remove) padding from the bounding box. If `T` is given,
return the bounding box as a box of type `T`.
"""
function boundingbox(indices::CartesianIndex...; pad = 0)
    (x1, y1), (x2, y2) = Tuple.(extrema(indices))
    XYXYBox(x1 - pad, y1 - pad, x2 + pad, y2 + pad)
end

boundingbox(indices::NTuple{2, Integer}...; kwargs...) =
    boundingbox(CartesianIndex.(indices)...; kwargs...)

boundingbox(::Type{B}, args...; kwargs..., ) where {B <: AbstractBox} =
    convert(B, boundingbox(args...; kwargs...))

"""
	boundingbox([T,] mask; pad = 0)

Computes the circumscribing bounding box for the given `mask`.
"""
boundingbox(mask::BitMatrix; kwargs...) = boundingbox(findall(mask)...; kwargs...)
boundingbox(::Type{B}, mask::BitMatrix; kwargs...) where {B <: AbstractBox} =
    boundingbox(B, findall(mask)...; kwargs...)

"""
    boundingbox([T, ] boxes...; pad = 0)

Computes the circumscribing bounding box for the given `boxes`. If `boxes` are
of different types, we return a bounding box with the same type as
`first(boxes)`. If a destination type `T` is provided, we return boxes as that
type.
"""
boundingbox(::Type{B}, boxes::AbstractVector{AbstractBox}; kwargs...) where {B <: AbstractBox} =
    boundingbox(B, (topleft.(boxes)..., bottomright.(boxes)...)...; kwargs...)

boundingbox(boxes::Vararg{AbstractBox}; kwargs...) =
    boundingbox([box for box in boxes]; kwargs...)

boundingbox(boxes::AbstractVector{AbstractBox}; kwargs...) =
    boundingbox(typeof(first(boxes)), boxes; kwargs...)
