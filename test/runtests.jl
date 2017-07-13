using Angles
using Base.Test

@test all(Radian(Degree(Radian(x))).x ≈ x for x in -10:rand():10)

@test all(Degree(x) == x for x in Degree.(-10:rand():10))
@test all(Radian(x) == x for x in Radian.(-10:rand():10))

for fun in (:sin, :sinc, :cos, :cosc, :tan, :sec, :csc, :cot), degree in -89:50rand():89
    radian = deg2rad(degree)
    goal = @eval $fun($radian)
    @test @eval $fun(Degree($degree)) ≈ $fun(Radian($radian)) ≈ $goal
end

for fun in (:sin, :cos), x in -1:rand():1
    @test @eval $(Symbol("arc$(fun)"))($x).x ≈ $(Symbol("a$(fun)"))($x)
end

for fun in (:sec, :csc), y in 1:rand():10, x in [y, -y]
    @test @eval $(Symbol("arc$(fun)"))($x).x ≈ $(Symbol("a$(fun)"))($x)
end

for fun in (:tan, :cot), x in -10:2rand():10
    @test @eval $(Symbol("arc$(fun)"))($x).x ≈ $(Symbol("a$(fun)"))($x)
end

@test all(arctan2(y, x) == Radian(atan2(y, x)) for x in -10:rand():10, y in -10:rand():10)
