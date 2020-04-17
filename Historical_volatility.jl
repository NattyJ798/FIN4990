# @ author Nathanael Judge
# nzjudge@mtu.edu

module Historical_volatility
using PyCall, DataFrames, CSV, Statistics, DataFrames
export convertData

py"""
import numpy as np
import pandas as pd
import pandas_datareader.data as web
import datetime

def read_data(ticker, end_date, start_date, data_source = 'yahoo'):

    historical_prices = web.DataReader(ticker, data_source, start=start_date,end=end_date)
    historical_prices['Logreturn'] = np.log(historical_prices['Close'] / historical_prices['Close'].shift(1))
    historical_prices['Volatility'] = historical_prices['Logreturn'].rolling(window=30).std() * np.sqrt(252)
    historical_prices.reset_index(inplace = True)
    return(historical_prices['Date'].dt.strftime("%Y-%m-%d"),historical_prices['Volatility'])

"""


# readData
# return calls in the python
function convertData(ticker::String = "GM", end_date::String = "2020-04-17", start_date::String = "2020-01-01", data_source::String = "yahoo", calculate::Bool = false)


pyob_date, pyob_vol = py"read_data"(ticker, end_date, start_date, data_source)

date = PyCall.convert(Array, pyob_date)
vol = PyCall.convert(Array, pyob_vol)

df = DataFrame(Date = date, Historical_Volatility = vol )
return(df)

end

end
