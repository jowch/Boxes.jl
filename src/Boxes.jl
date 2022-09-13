module Boxes

import Base: ==, contains, convert, to_indices

export

# types
AbstractBox, CenterBox, CornerBox, XYXYBox,

# methods
width, height, center, topleft, topright, bottomleft, bottomright,
flip, ==, convert, to_indices, corners, area, contains, iou, distance,

# bbox
boundingbox


include("abstract.jl")
include("center.jl")
include("corner.jl")
include("xyxy.jl")
include("bbox.jl")

end # module Boxes
