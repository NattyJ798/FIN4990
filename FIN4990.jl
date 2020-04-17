using Pkg
pkg"activate ."


include("Black_scholes.jl")
include("Historical_volatility.jl")
using .Black_scholes, .Historical_volatility

# use this https://www.optionseducation.org/toolsoptionquotes/optionscalculator
# to compare
Black_scholes.test()

Historical_volatility.convertData()
