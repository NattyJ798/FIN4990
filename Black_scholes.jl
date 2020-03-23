# @ author Nathanael Judge
# A program that

# packages
# Distributions
# needed for calculating the normal distribution
# probabilities
using Random, Distributions, DataFrames

# run_black_scholes
# calculates black scholes price
# accepts

# calculate_d1
# accepts stock price, strike price, implied volitility
# risk-free rate, and time to maturity in years
# calculates the d1 component of the bsm formula
function calculate_d1(S, X, σ, r, t)
    part1 = log(S / X)
    part2 = (r + σ ^ 2 / 2) * t
    part3 = sqrt(σ ^ 2 * t)
    return((part1 + part2) / part3)
end

# calculate_d2
# accepts stock price, strike price, implied volitility
# risk-free rate, and time to maturity in years
# calculates the d1 component of the bsm formula
function calculate_d2(S, X, σ, r, t)
    part1 = log(S / X)
    part2 = (r - σ ^ 2 / 2) * t
    part3 = sqrt(σ ^ 2 * t)
    return((part1 + part2) / part3)
end

# BSM_fair_value
# accepts the stock price, strike price
# implied volitility, risk-free rate
# time to maturity in years
# and whether or not it's a call option
# function calculates fair price of the call/put
function BSM_fair_value(S, X, σ, r, t, call = true)
    # make sure type of input is correct for call
    if typeof(call) != Bool
        println("Call must be true or false.")
        println("BSM_fair_value(52,50,0.12,0.05, 0.5, True)")
        error()
    end
    if call == true
        #  if it's a call, compute the call formula
        Part1 =  S * cdf(Normal(), calculate_d1(S, X, σ, r, t))
        Part2 = X * ℯ^(-r * t) * cdf(Normal(),  calculate_d2(S, X, σ, r, t))
        V = Part1 - Part2
    elseif call == false
        Part1 =  S * cdf(Normal(), -calculate_d1(S, X, σ, r, t))
        Part2 = X * ℯ^(-r * t) * cdf(Normal(),  -calculate_d2(S, X, σ, r, t))
        V = -Part1 + Part2
    end
    # return the value
    return(round(V, digits=3))
end

# get_theta
# accepts stock price, strike price, implied volitility
# risk-free rate, and time to maturity in years
# calculates the greek Θ
function get_theta( S, X, σ, r, t, call = true)
    # make sure that call is a boolean
    # otherwise, through a helpful error message
    if typeof(call) != Bool
        println("Call must be true or false.")
        println("get_theta(52,50,0.12,0.05, 0.5, True)")
        error()
    end
    if call == true
        # if it's a call, use the call formula
        part1 =  -S * σ / (2 * √(t)) * pdf(Normal( ), calculate_d1(S, X, σ, r, t))
        part2 = -r * X * ℯ^(-r * t) * cdf(Normal( ), calculate_d2(S, X, σ, r, t))
        Θ = part1 + part2
    elseif call == false
        # if it's a put, use the put formula
        part1 =  -S * σ / (2 * √(t)) * pdf(Normal( ), calculate_d1(S, X, σ, r, t))
        part2 = r * X * ℯ^(-r * t) * cdf(Normal( ), -calculate_d2(S, X, σ, r, t))
        Θ = part1 + part2
    end
    return(round(Θ,digits=3))
end

# get_delta
# accepts stock price, strike price, implied volitility
# risk-free rate, and time to maturity in years
# and whether it's a call or put
# calculates the greek Δ
# # https://en.wikipedia.org/wiki/Greeks_(finance)
function get_delta( S, X, σ, r, t, call = true)
    # make sure that call is a boolean
    # otherwise, through a helpful error message
    if typeof(call) != Bool
        println("Call must be true or false.")
        println("get_delta(52,50,0.12,0.05, 0.5, True)")
        error()
    end
    if call == true
        # if it's a call, use the call formula
        Δ = ℯ^(-r*t) * cdf(Normal(), calculate_d1(S, X, σ, r, t))
    elseif call == false
        # if it's a put, use the put formula
        Δ = -ℯ^(-r*t) * cdf(Normal(), -calculate_d1(S, X, σ, r, t))
    end
    return(round(Δ, digits=3))
end
# get_gamma
# accepts stock price, strike price, implied volitility
# risk-free rate, and time to maturity in years
# calculates the greek gamma
# https://en.wikipedia.org/wiki/Greeks_(finance)
function get_gamma(S, X, σ, r, t)
    γ = pdf(Normal(), calculate_d1(S, X, σ, r, t)) / (S * σ * √(t))
    return(round(γ, digits=3))

end

# get_vega
# accepts stock price, strike price, implied volitility
# risk-free rate, and time to maturity in years
# calculates the greek vega
# https://en.wikipedia.org/wiki/Greeks_(finance)
function get_vega(S, X, σ, r, t)
    vega = S  * √(t) * pdf(Normal(), calculate_d1(S, X, σ, r, t)) * 1/100
    return(round(vega, digits=3))
end

# get_rho
# accepts stock price, strike price, implied volitility
# risk-free rate, and time to maturity in years, and
# whether it's for a call or put
# calculates the greek ρ
# https://en.wikipedia.org/wiki/Greeks_(finance)
function get_rho(S, X, σ, r, t, call = true)
    # make sure that call is a boolean
    # otherwise, through a helpful error message
    if typeof(call) != Bool
        println("Call must be true or false.")
        println("get_rho(52,50,0.12,0.05, 0.5, True)")
        error()
    end
    if call == true
        # if it's a call, use the call formula
        ρ = X * t * ℯ^(-r*t) * cdf(Normal(), calculate_d2(S, X, σ, r, t))
    elseif call == false
        # if it's a put, use the put formula
        ρ = -X * t * ℯ^(-r*t) * cdf(Normal(), -calculate_d2(S, X, σ, r, t))
    end
    return(round(ρ/100, digits=3))
end




# use this https://www.optionseducation.org/toolsoptionquotes/optionscalculator
# to compare
function test( )
t = 3 / 12
r = 0.025
X = 79
S = 69
σ = 0.80
Data = zeros(6,2)
Data[1,:] = [BSM_fair_value(S, X, σ, r, t), BSM_fair_value(S, X, σ, r, t, false)]
Data[2,:] = [get_delta(S, X, σ, r, t), get_delta(S, X, σ, r, t, false)]
Data[3,:] = [get_gamma(S, X, σ, r, t), get_gamma(S, X, σ, r, t)]
Data[4,:] = [get_theta(S, X, σ, r, t), get_theta(S, X, σ, r, t, false)]
Data[5,:] = [get_vega(S, X, σ, r, t), get_vega(S, X, σ, r, t)]
Data[6,:] = [get_rho(S, X, σ, r, t), get_rho(S, X, σ, r, t, false)]
df = DataFrame(Type = ["Option Value", "Δ", "γ", "θ", "Vega", "ρ"],Call = Data[:,1], Put = Data[:,2])
print("$df")
end
