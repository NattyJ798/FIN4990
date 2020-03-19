# packages

# Distributions
# needed for calculating the normal distribution
# probabilities
using Random, Distributions

# run_black_scholes
# calculates black scholes price
# accepts

# calculate_d1
# accepts stock price, strike price, implied volitility
# risk-free rate, and time to maturity in years
# calculates the d1 component of the bsm formula
function calculate_d1(stock_price, strike_price, σ, rate, t)
    part1 = log(stock_price / strike_price)
    part2 = (rate + σ ^ 2 / 2) * t
    part3 = sqrt(σ ^ 2 * t)
    return((part1 + part2) / part3)
end

# calculate_d1
# accepts stock price, strike price, implied volitility
# risk-free rate, and time to maturity in years
# calculates the d1 component of the bsm formula
function calculate_d2(stock_price, strike_price, σ, rate, t)
    part1 = log(stock_price / strike_price)
    part2 = (rate - σ ^ 2 / 2) * t
    part3 = sqrt(σ ^ 2 * t)
    return((part1 + part2) / part3)
end

# BSM_fair_value
# accepts the stock price, strike price
# implied volitility, risk-free rate
# time to maturity in years
# and whether or not it's a call option
# function calculates fair price of the call/put
function BSM_fair_value( S, X, σ, r, t, call = true)
    # make sure type of input is correct for call
    if typeof(call) != Bool
        println("Call must be true or false.")
        println("BSM_fair_value(52,50,0.12,0.05, 0.5, True)")
        error()
    end
    # set seed
    Random.seed!(1234)
    # calculate the cdf of d1
    𝚽_n_d1 = cdf(Normal(), calculate_d1(S, X, σ, r, t))
    # calculate the cdf of d2
    𝚽_n_d2 = cdf(Normal(),  calculate_d2(S, X, σ, r, t))
    if call == true
        #  if it's a call, compute the call formula
        V = S * 𝚽_n_d1 - X * ℯ^(-r * t) * 𝚽_n_d2
    elseif call == false
        # if it's a put, compute the put formula
        V = S * 𝚽_n_d1 - X * ℯ^(-r * t) * 𝚽_n_d2
    end
    # return the value
    return(V)
end

# get_delta
# accepts stock price, strike price, implied volitility
# risk-free rate, and time to maturity in years
# calculates the greek Δ
function get_delta( S, X, σ, r, t, call = true)
    # make sure that call is a boolean
    # otherwise, through a helpful error message
    if typeof(call) != Bool
        println("Call must be true or false.")
        println("BSM_fair_value(52,50,0.12,0.05, 0.5, True)")
        error()
    end
    if call = true
        # if it's a call, use the call formula
        Δ = ℯ^(-r*t) * cdf(Normal(), calculate_d1(S, X, σ, r, t))
    elseif call = false
        # if it's a put, use the put formula
        Δ = -ℯ^(-r*t) * cdf(Normal(), calculate_d1(S, X, σ, r, t))
    end
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
        println("BSM_fair_value(52,50,0.12,0.05, 0.5, True)")
        error()
    end
    if call = true
        # if it's a call, use the call formula
        Δ = ℯ^(-r*t) * cdf(Normal(), calculate_d1(S, X, σ, r, t))
    elseif call = false
        # if it's a put, use the put formula
        Δ = -ℯ^(-r*t) * cdf(Normal(), calculate_d1(S, X, σ, r, t))
    end
    return(Δ)
end

# get_vega
# accepts stock price, strike price, implied volitility
# risk-free rate, and time to maturity in years
# calculates the greek vega
# https://en.wikipedia.org/wiki/Greeks_(finance)
function get_vega(S, X, σ, r, t)
    return(S * ℯ^(-r*t) * pdf(Normal(), calculate_d1(S,X, σ, r, t)) * √(t) )
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
        println("BSM_fair_value(52,50,0.12,0.05, 0.5, True)")
        error()
    end
    if call = true
        # if it's a call, use the call formula
        ρ = X * t * ℯ^(-r*t) cdf(Normal(), calculate_d2(S, X, σ, r, t))
    elseif call = false
        # if it's a put, use the put formula
        ρ = -X * -ℯ^(-r*t) * cdf(Normal(), calculate_d2(S, X, σ, r, t))
    end

end



function test( )
t = 6 / 12
r = 0.05
X = 50
S = 52
σ = 0.12
# test_output = round(run_black_scholes(S, X, σ, r, t), digits=3)
BSM_fair_value(S, X, σ, r, t)
#println("This is what I got $test_output. This is what it should be 3.788")
end
