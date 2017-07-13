__precompile__()

module Angles

import Base: sin, sinc, asin, cos, cosc, acos, tan, atan, sec, asec, csc, acsc, cot, acot, atan2, rad2deg, deg2rad 

export Angle, Degree, Radian, Proportion

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

"""
    Proportion{T <: Number}(x::T)

Wrap a `Number` number as a proportion of π (or 180°).
# Examples
Define 0.5 radians:
```jldoctest
julia> Proportion(0.5)
Angles.Proportion{Float64}(0.5)
```
"""
struct Proportion{T <: Number} <: Angle
    x::T
end

# convert
rad2deg(x::Radian) = Degree(rad2deg(x.x))
Degree(x::Radian) = rad2deg(x)
Degree(x::Proportion) = Degree(180x.x)
Degree(x::Degree) = x
deg2rad(x::Degree) = Radian(deg2rad(x.x))
Radian(x::Degree) = deg2rad(x)
Radian(x::Proportion) = Radian(π*x.x)
Radian(x::Radian) = x
Proportion(x::Radian) = Proportion(x.x/π)
Proportion(x::Degree) = Proportion(x.x/180)
Proportion(x::Proportion) = x

# trigo
sinc(x::Radian) = sinc(x.x)
sinc(x::Degree) = sinc(deg2rad(x))
sinc(x::Proportion) = sinc(Radian(x))
cosc(x::Radian) = cosc(x.x)
cosc(x::Degree) = cosc(deg2rad(x))
cosc(x::Proportion) = cosc(Radian(x))

for fun in (:sin, :cos, :tan, :sec, :csc, :cot)
    @eval begin
        $fun(x::Degree) = $(Symbol("$(fun)d"))(x.x)
        $fun(x::Radian) = $fun(x.x)
        $(Symbol("a$(fun)"))(::Type{T}, x::Number) where {T <: Angle} = T(Radian($(Symbol("a$(fun)"))(x)))
    end
end

sin(x::Proportion) = sinpi(x.x)
cos(x::Proportion) = cospi(x.x)
asin(Proportion, x::Number) = Proportion(Radian(asin(x)))
acos(Proportion, x::Number) = Proportion(Radian(acos(x)))

for fun in (:tan, :sec, :csc, :cot)
    @eval begin
        $fun(x::Proportion) = $fun(Radian(x))
        $(Symbol("a$(fun)"))(Proportion, x::Number) = Proportion(Radian($(Symbol("a$(fun)"))(x)))
    end
end

atan2(::Type{T}, y::Number, x::Number) where {T <: Angle} = T(Radian(atan2(y, x)))

end # module
