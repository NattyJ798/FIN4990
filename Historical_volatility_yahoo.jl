# @ author Nathanael Judge
# nzjudge@mtu.edu

using PyCall, DataFrames, CSV, Statistics

py"""
import numpy as np
import pandas as pd
import pandas_datareader.data as web
import datetime

def main():
    ticker='GM'
    end_date = datetime.date.today()
    start_date=end_date.replace(year=end_date.year-1)

    historical_prices = web.DataReader(ticker, data_source='yahoo',start=start_date,end=end_date)
    print(historical_prices)
    historical_prices['Logreturn'] = np.log(historical_prices['Close'] / historical_prices['Close'].shift(1))
    print(historical_prices['Logreturn'])
    historical_prices['Volatility'] = historical_prices['Logreturn'].rolling(window=30).std() * np.sqrt(252)
    print(historical_prices['Volatility']);
"""
