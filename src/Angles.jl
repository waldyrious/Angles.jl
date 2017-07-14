__precompile__()

module Angles

import Base: sin, sinc, asin, cos, cosc, acos, tan, atan, sec, asec, csc, acsc, cot, acot, atan2, rad2deg, deg2rad 

export Angle, Degree, Radian, Multiple

abstract type Angle <: Number end

"""
    Degree{T <: Number}(x::T)

Wrap a `Number` number as a degree.
# Examples
Define 45°:
```jldoctest
julia> using Angles
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
julia> using Angles
julia> Angles.Radian(π)
Angles.Radian{Irrational{:π}}(π = 3.1415926535897...)
```
"""
struct Radian{T <: Number} <: Angle
    x::T
end

"""
    Multiple{T <: Number}(x::T)

Wrap a `Number` number as a multiple of π (or 180°).
# Examples
Define 0.5 radians:
```jldoctest
julia> using Angles
julia> Angles.Multiple(0.5)
Angles.Multiple{Float64}(0.5)
```
"""
struct Multiple{T <: Number} <: Angle
    x::T
end

# convert
rad2deg(x::Radian) = Degree(rad2deg(x.x))
Degree(x::Radian) = rad2deg(x)
Degree(x::Multiple) = Degree(180x.x)
Degree(x::Degree) = x
deg2rad(x::Degree) = Radian(deg2rad(x.x))
Radian(x::Degree) = deg2rad(x)
Radian(x::Multiple) = Radian(π*x.x)
Radian(x::Radian) = x
Multiple(x::Radian) = Multiple(x.x/π)
Multiple(x::Degree) = Multiple(x.x/180)
Multiple(x::Multiple) = x

# trigo
sinc(x::Radian) = sinc(x.x)
sinc(x::Degree) = sinc(deg2rad(x))
sinc(x::Multiple) = sinc(Radian(x))
cosc(x::Radian) = cosc(x.x)
cosc(x::Degree) = cosc(deg2rad(x))
cosc(x::Multiple) = cosc(Radian(x))

for fun in (:sin, :cos, :tan, :sec, :csc, :cot)
    @eval begin
        $fun(x::Degree) = $(Symbol("$(fun)d"))(x.x)
        $fun(x::Radian) = $fun(x.x)
        $(Symbol("a$(fun)"))(::Type{T}, x::Number) where {T <: Angle} = T(Radian($(Symbol("a$(fun)"))(x)))
    end
end

sin(x::Multiple) = sinpi(x.x)
cos(x::Multiple) = cospi(x.x)
asin(Multiple, x::Number) = Multiple(Radian(asin(x)))
acos(Multiple, x::Number) = Multiple(Radian(acos(x)))

for fun in (:tan, :sec, :csc, :cot)
    @eval begin
        $fun(x::Multiple) = $fun(Radian(x))
        $(Symbol("a$(fun)"))(Multiple, x::Number) = Multiple(Radian($(Symbol("a$(fun)"))(x)))
    end
end

atan2(::Type{T}, y::Number, x::Number) where {T <: Angle} = T(Radian(atan2(y, x)))

end # module
