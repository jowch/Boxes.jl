"""
	CenterBox(x, y, h, w)

A box is a... It is defined by...
"""
struct CenterBox{T<:Integer} <: AbstractBox
    x::T
    y::T
    w::T
    h::T
end

convert(::Type{<:CenterBox}, b::AbstractBox) =
    CenterBox(floor.(Int, center(b))..., width(b), height(b))

width(box::CenterBox) = box.w
height(box::CenterBox) = box.h
center(box::CenterBox) = (box.x, box.y)
topleft(box::CenterBox) = (box.x - box.w ÷ 2, box.y - box.h ÷ 2)
topright(box::CenterBox) = (box.x + box.w ÷ 2, box.y - box.h ÷ 2)
bottomleft(box::CenterBox) = (box.x - box.w ÷ 2, box.y + box.h ÷ 2)
bottomright(box::CenterBox) = (box.x + box.w ÷ 2, box.y + box.h ÷ 2)
flip(box::CenterBox) = CenterBox(box.y, box.x, box.h, box.w)
