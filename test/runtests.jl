using Angles
using Base.Test

@test all(Multiple(Radian(Degree(Radian(Multiple(x))))).x ≈ x for x in -10:rand():10)

@test all(Degree(x) == x for x in Degree.(-10:rand():10))
@test all(Radian(x) == x for x in Radian.(-10:rand():10))
@test all(Multiple(x) == x for x in Multiple.(-10:rand():10))

for fun in (:sin, :sinc, :cos, :cosc, :tan, :sec, :csc, :cot), degree in -89:50rand():89
    radian = deg2rad(degree)
    multiple = degree/180
    goal = @eval $fun($radian)
    @test @eval $fun(Degree($degree)) ≈ $fun(Radian($radian)) ≈ $fun(Multiple($multiple)) ≈ $goal
end

for fun in (:sin, :cos), x in -1:rand():1
    @test @eval $(Symbol("a$(fun)"))(Degree, $x).x ≈ $(Symbol("a$(fun)d"))($x)
end

for fun in (:sec, :csc), y in 1:rand():10, x in [y, -y]
    @test @eval $(Symbol("a$(fun)"))(Radian, $x).x ≈ $(Symbol("a$(fun)"))($x)
end

for fun in (:tan, :cot), x in -10:2rand():10
    @test @eval $(Symbol("a$(fun)"))(Multiple, $x).x ≈ $(Symbol("a$(fun)"))($x)/π
end

@test all(atan2(Degree, y, x) == Degree(rad2deg(atan2(y, x))) for x in -10:rand():10, y in -10:rand():10)
