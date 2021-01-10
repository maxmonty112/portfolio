# Portfolio
This is a super simple server that updates prices of my crypto, stock, and etf holdings in an airtable sheet that I used to track my investments and net worth. Right now, I manually input the cryptocurrencies and stocks and quantities I own. This server runs a job once a day to update the price per share/coin. 

I have a number of other investments besides public equities. I have to update the value of these manually. Overtime I hope to expand this server to integrate with angellist and other services to automate tracking of all my investments. Consider this service a WIP. 

I have included a .env.example file so you can easily clone this repo and set up a similar portfolio for yourself. It will just require getting your own API tokens and inputting your own Airtable info. I am using APIs from Airtable, Alphavantage, and CoinMarketCap. I will include more details soon about how to set this up.

To pick up where I left off, [here](https://airtable.com/shrhHKq8pSO4ws0e2) is a clone of my Airtable base with example portfolio holdings (not my actual lol). Feel free to copy. Only thing missing in the example base is my automations which I will copy over soon.  

**Example output**

```
$ npm run start

> net_worth@1.0.0 start /Users/maxmontgomery/projects/portfolio
> tsc && node dist/app.js

2021-01-10T23:43:43.182Z [INFO]: Server started. Metadata: {"time":"2021-01-10T23:43:43.180Z"}
2021-01-10T23:43:43.185Z [INFO]: Crypto price update job started. Metadata: {"time":"2021-01-10T23:43:43.185Z"}
2021-01-10T23:43:48.328Z [INFO]: Crypto prices updated. Metadata: {"tickers":["ETH","BTC"],"time":"2021-01-10T23:43:48.328Z"}
2021-01-10T23:43:48.329Z [INFO]: Crypto price update job ended. Metadata: {"time":"2021-01-10T23:43:48.329Z"}
2021-01-10T23:44:43.186Z [INFO]: Stock price update job started. Metadata: {"time":"2021-01-10T23:44:43.186Z"}
2021-01-10T23:45:44.658Z [INFO]: Stock prices updated. Metadata: {"tickers":["HERO","AAPL","SQ","SFIX","VTTSX"],"time":"2021-01-10T23:45:44.658Z"}
2021-01-10T23:46:47.437Z [INFO]: Stock prices updated. Metadata: {"tickers":["PLTR","SFYX","VEA","SPLK","TSLA"],"time":"2021-01-10T23:46:47.436Z"}
2021-01-10T23:47:44.844Z [INFO]: Stock prices updated. Metadata: {"tickers":["QQQ","BETZ","UBER","BLOK","BYND"],"time":"2021-01-10T23:47:44.843Z"}
```
