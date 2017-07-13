module Angles

import Base: sin, sinc, cos, cosc, tan, sec, csc, cot, rad2deg, deg2rad 

export Angle, Degree, Radian, arcsin, arccos, arctan, arcsec, arccsc, arccot, arctan2

abstract type Angle end

"""
    Degree{T <: Real}(x::T)

Wrap a `Real` number as a degree.
# Examples
Define 45°:
```jldoctest
julia> Degree(45)
Angles.Degree{Int64}(45)
```
"""
struct Degree{T <: Real} <: Angle
    x::T
end

"""
    radian{T <: Real}(x::T)

Wrap a `Real` number as a radian.
# Examples
Define π radians:
```jldoctest
Radian(π)
Angles.Radian{Irrational{:π}}(π = 3.1415926535897...)
```
"""
struct Radian{T <: Real} <: Angle
    x::T
end

# convert
rad2deg(x::Radian) = Degree(rad2deg(x.x))
Degree(x::Radian) = rad2deg(x)
Degree(x::Degree) = x
deg2rad(x::Degree) = Radian(deg2rad(x.x))
Radian(x::Degree) = deg2rad(x)
Radian(x::Radian) = x

# trigo
sinc(x::Degree) = sinc(deg2rad(x))
sinc(x::Radian) = sinc(x.x)
cosc(x::Degree) = cosc(deg2rad(x))
cosc(x::Radian) = cosc(x.x)

for fun in (:sin, :cos, :tan, :sec, :csc, :cot)
    @eval begin
        $fun(x::Degree) = $(Symbol("$(fun)d"))(x.x)
        $fun(x::Radian) = $fun(x.x)
        $(Symbol("arc$(fun)"))(x::Number) = Radian($(Symbol("a$(fun)"))(x))
    end
end

arctan2(y::Number, x::Number) = Radian(atan2(y, x))

end # module
