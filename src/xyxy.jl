"""
    XYXYBox(x₁, y₁, x₂, y₂)

A `XYXYBox` is a box defined by the `topleft (x₁, y₁)` and `bottomright (x₂, y₂)` corners. The `topleft` corner is expected to be the smallest magnitude corner.
"""
struct XYXYBox{T<:Integer} <: AbstractBox
    x₁::T
    y₁::T
    x₂::T
    y₂::T
end

convert(::Type{<:XYXYBox}, b::AbstractBox) =
    XYXYBox(topleft(b)..., bottomright(b)...)

width(box::XYXYBox) = abs(box.x₂ - box.x₁)
height(box::XYXYBox) = abs(box.y₂ - box.y₁)
topleft(box::XYXYBox) = (box.x₁, box.y₁)
topright(box::XYXYBox) = (box.x₂, box.y₁)
bottomleft(box::XYXYBox) = (box.x₁, box.y₂)
bottomright(box::XYXYBox) = (box.x₂, box.y₂)
flip(box::XYXYBox) = XYXYBox(box.y₁, box.x₁, box.y₂, box.x₂)
