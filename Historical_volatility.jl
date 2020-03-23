# using Conda
# Conda.add("quandl")

# Packages
using PyCall, DataFrames


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
    df.to_csv(text_doc, index = False, header = True)
    return(text_doc)
"""






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
