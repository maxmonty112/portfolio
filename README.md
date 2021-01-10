# portfolio
This is a super simple server that updates prices of my crypto, stock, and etf holdings in an airtable sheet that I used to track my investments and net worth. Right now, I manually input the cryptocurrencies and stocks and quantities I own. This server runs a job once a day to update the price per share/coin. 

I have a number of other investments besides public equities. I have to update the value of these manually. Overtime I hope to expand this server to integrate with angellist and other services to automate tracking of all my investments. Consider this service a WIP. 

I have included a .env.example file so you can easily clone this repo and set up a similar portfolio for yourself. It will just require getting your own API tokens and inputting your own Airtable info. I am using APIs from Airtable, Alphavantage, and CoinMarketCap. 

To pick up where I left off, [here](https://airtable.com/shrhHKq8pSO4ws0e2) is a clone of my Airtable base with example portfolio holdings (not my actual lol). Feel free to copy. Only thing missing in the example base is my automations which I will copy over soon.  
>>>>>>> ebe47b88b2eede24fb5b19efda0a94b625810368
