module Angles

import Base: sin, sinc, asin, cos, cosc, acos, tan, atan, sec, asec, csc, acsc, cot, acot, atan2, rad2deg, deg2rad 

export Angle, Degree, Radian

abstract type Angle <: Number end

"""
    Degree{T <: Number}(x::T)

Wrap a `Number` number as a degree.
# Examples
Define 45°:
```jldoctest
julia> Degree(45)
Angles.Degree{Int64}(45)
```
"""
struct Degree{T <: Number} <: Angle
    x::T
end

"""
    radian{T <: Number}(x::T)

Wrap a `Number` number as a radian.
# Examples
Define π radians:
```jldoctest
Radian(π)
Angles.Radian{Irrational{:π}}(π = 3.1415926535897...)
```
"""
struct Radian{T <: Number} <: Angle
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
        $(Symbol("a$(fun)"))(::Type{T}, x::Number) where {T <: Angle} = T(Radian($(Symbol("a$(fun)"))(x)))
    end
end

atan2(::Type{T}, y::Number, x::Number) where {T <: Angle} = T(Radian(atan2(y, x)))

end # module
