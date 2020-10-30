import alphavantage from "alphavantage";
import airtable from "airtable";
import dotenv from "dotenv";
import _ from "lodash";

dotenv.config();

airtable.configure({
    apiVersion: undefined, noRetryIfRateLimited: undefined,
    endpointUrl: process.env.AIRTABLE_URL,
    apiKey: process.env.AIRTABLE_API_KEY
});

type TickerAndRowId = {
    ticker: string;
    id: string;
};

//TODO: add logging
//TODO: update file structure

const main = async () => {
    try {
        const alpha = alphavantage({key: process.env.ALPHAVANTAGE_API_KEY_2});
        const base = airtable.base(process.env.AIRTABLE_BASE);
        const records = await base('Stocks').select().all();
        const tickersAndIds: TickerAndRowId[] = records.map((record) => {
            return {ticker: record.fields.Ticker, id: record.id}
        });
        const chunks: TickerAndRowId[][] = _.chunk(tickersAndIds, 5);
        let chunkNumber = 0;
        const setPrices = async (chunk: TickerAndRowId[]) => {
            const results = await Promise.all(chunk.map(async (tickerAndId) => {
                const quote = await alpha.data.quote(tickerAndId.ticker);
                const id = tickerAndId.id;
                return {quote, id};
            }));
            const prices = results.map((result) => {
                const object = result.quote["Global Quote"];
                return {Ticker: object["01. symbol"], Price: parseFloat(object["05. price"]), Id: result.id}
            });
            await Promise.all(prices.map(async (price) => {
                await base('Stocks').update(price.Id, {Price: price.Price});
            }));
        };
        await Promise.all(chunks.map(async (chunk) => {
            if (chunkNumber > 0) {
                await setTimeout(async () => {
                    await setPrices(chunk);
                    chunkNumber++;
                    },
                    60000);
            } else {
                chunkNumber++;
                await setPrices(chunk);
            }
        }));
    } catch (e) {
        console.log(e);
    }
};

main();
