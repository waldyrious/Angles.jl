# Angles

[![Build Status](https://travis-ci.org/yakir12/Angles.jl.svg?branch=master)](https://travis-ci.org/yakir12/Angles.jl)

[![Coverage Status](https://coveralls.io/repos/yakir12/Angles.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/yakir12/Angles.jl?branch=master)

[![codecov.io](http://codecov.io/github/yakir12/Angles.jl/coverage.svg?branch=master)](http://codecov.io/github/yakir12/Angles.jl?branch=master)

Is it a radian? Is it a degree? Who cares! 

`Angles.jl` introduces an `Angle` type that wraps your angles as `Degree` or `Radian`, making sure all the trigonemetric functions work as expected. You'll never need to worry about using `sin` or `sind`.

Here's an example:
```
julia> α = Degree(30)
Angles.Degree{Int64}(30)

julia> sin(α)
0.5

julia> β = Radian(π)
Angles.Radian{Irrational{:π}}(π = 3.1415926535897...)

julia> cos(β)
-1.0
```

The approach `Angles.jl` takes is adding approproate methods to `sin`, `sinc`, `cos`, `cosc`, `tan`, `sec`, `csc`, and `cot` so that they accept `Degree` and `Radian`. We excluded the `d` versions of these functions (e.g. `sind`) to keep things simple (and to avoid overriding any intended behavior by the user). 

For inverse functions, `arccos`, `arccot`, `arccsc`, `arcsec`, `arcsin`, `arctan`, and `arctan2` will return the correct angle in `Radian`s:
```
julia> arcsin(0)
Angles.Radian{Float64}(0.0)
```

Because all the trigonometric functions work correctly regardless of the type of their argument (i.e. `Degree` or `Radian`), there is no need to convert between the two units. However, to specifically convert one unit to the other, use the type instances:
```
julia> β = Radian(π/2)
Angles.Radian{Float64}(1.5707963267948966)

julia> α = Degree(β)
Angles.Degree{Float64}(90.0)

julia> Radian(α)
Angles.Radian{Float64}(1.5707963267948966)
```

The computational cost for this functionality should be negligable. To keep it that way, many arguably relevant functionalities were excluded. Some of the excluded functionalities are: directionality (i.e. clockwise versus counterclockwise), auto-wraping, auto-eliciting the `sinpi` versions, and fixed-point arithmetic for additional accuracy. 

The major disadvantage of this package (in its current, 2017-07, state) is the fact that there are no additional functions defined for subtypes of `Angle` (e.g. `+`, `*`, `√`). This needs to be fixed.
