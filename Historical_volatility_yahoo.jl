# @ author Nathanael Judge
# nzjudge@mtu.edu

module Historical_Volatility
using PyCall, DataFrames, CSV, Statistics
export readData

py"""
import numpy as np
import pandas as pd
import pandas_datareader.data as web
import datetime

def read_data(ticker, end_date, start_date):


    historical_prices = web.DataReader(ticker, data_source='yahoo',start=start_date,end=end_date)
    historical_prices['Logreturn'] = np.log(historical_prices['Close'] / historical_prices['Close'].shift(1))
    historical_prices['Volatility'] = historical_prices['Logreturn'].rolling(window=30).std() * np.sqrt(252)
    return(historical_prices['Volatility'])

"""

# readData
# return the historical data
function readData(ticker, end_date, start_date)
return(py"read_data"(ticker,end_date, start_date))

end
end
