# author Nathanael Judge(could we write a julia script)
# notes

# using Conda
# Conda.add("quandl")

# Packages
using PyCall, DataFrames, CSV, Statistics


# get_Stock( )
# reads in a desired symbol using Quandl's python API
# calls in a python script
# this is inefficient but I don't have a better solution yet
# working on this

py"""
import quandl
import datetime as date
def get_stock(ticker, key_path = 'C:/Users/12699/Desktop/Quandl_key.txt', path = ""  ):
    file = open(key_path,'r')
    QUANDL_API_KEY = file.readlines()[0]
    quandl.ApiConfig.api_key = QUANDL_API_KEY
    df = quandl.get(ticker)
    # get the time
    Date = date.datetime.now( )
    text_doc = ticker.split("/")[0]+ticker.split("/")[1]+"_"+str(Date.year)+str(Date.month)
    text_doc += str(Date.day) + str(Date.hour) + str(Date.minute) +".csv"
    df.to_csv(path+text_doc, index = False, header = True)
    return(path+text_doc)
"""

# read_file( )
# reads in stock information
# accepts the stock ticker
# path to the quandl key text file
# and path of where you want to save the file
function read_file(ticker::String, key_path::String = "", path::String = "")
    filename = py"get_stock"(ticker)
    data = CSV.read(filename)
    rm(filename)
    return(data)
end

# calculate_historical_σ( )
# calculates the historical voltility using the data acquired in
# read_file
# https://www.investopedia.com/ask/answers/021015/how-can-you-calculate-volatility-excel.asp
function calculate_historical_σ(data::DataFrame)
    column_names = names(data)
    div = zeros(length(Test[1:end-1,:Open]),1)
    if :Close in column_names
        div = data[2:end,:Close]/data[1:end-1, :Close]
    elseif :Last in column_names
        div = data[2:end,:Last]/data[1:end-1, :Last]
    end
    return(Statistics.std(div) * √(252))

end

# get_historical_σ( )
# gets the historical voltility for a given stock
function get_historical_σ(ticker::String, key_path::String = "", path::String = "")
    data = read_file(ticker, key_path, path)
    return(calculate_historical_σ(data))
end





# scrapped for now
# using Quandl since it's what's recommended in the python for finance I am
# reading.
# https://smile.amazon.com/Mastering-Python-Finance-state-art/dp/1789346460/ref=sr_1_1_sspa?crid=39FGYZB0LILS6&dchild=1&keywords=python+for+finance&qid=1584993381&sprefix=%2Caps%2C335&sr=8-1-spons&psc=1&spLa=ZW5jcnlwdGVkUXVhbGlmaWVyPUExVlFRQ0FCOTkyRjQzJmVuY3J5cHRlZElkPUEwNzUyMjAxM0M2QzVZTTVXR0VKNyZlbmNyeXB0ZWRBZElkPUEwMDc1MTY1NFA4WENFRUk2OVBGJndpZGdldE5hbWU9c3BfYXRmJmFjdGlvbj1jbGlja1JlZGlyZWN0JmRvTm90TG9nQ2xpY2s9dHJ1ZQ==
# Quandl = pyimport("quandl")
# pull_stock()
# pulls in the information for the provided ticker
# returns a python data frame(?) consider making it a julia one instead??
# using my path as a start
# function pull_stock(ticker::String, key_path::String = "C:/Users/12699/Desktop/Quandl_key.txt")
#         # read-in the API_key
#         QUANDL_API_KEY = readlines(key_path)[1]
#         # connect to the API
#         Quandl.ApiConfig.api_key = QUANDL_API_KEY
#         # get the PyObject
#         data = Quandl.get(ticker, returns = "pandas")
#         print(df)
#
# end
