using Pkg
pkg"activate ."


include("Black_scholes.jl")
using .Black_scholes

test()
