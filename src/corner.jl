"""
    CornerBox(x, y, w, h)

A `CornerBox` is a box defined by the `topleft (x, y)` corner, width `w`, and height `h`. The `topleft` corner is expected to be the smallest magnitude corner.
"""
struct CornerBox{T<:Integer} <: AbstractBox
    x::T
    y::T
    w::T
    h::T
end

convert(::Type{<:CornerBox}, b::AbstractBox) =
    CornerBox(topleft(b)..., width(b), height(b))

width(box::CornerBox) = box.w
height(box::CornerBox) = box.h
topleft(box::CornerBox) = (box.x, box.y)
topright(box::CornerBox) = (box.x + box.w, box.y)
bottomleft(box::CornerBox) = (box.x, box.y + box.h)
bottomright(box::CornerBox) = (box.x + box.w, box.y + box.h)
flip(box::CornerBox) = CornerBox(box.y, box.x, box.h, box.w)
