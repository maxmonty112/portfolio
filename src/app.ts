import alphavantage from "alphavantage";
import airtable from "airtable";

airtable.configure({
    apiVersion: undefined, noRetryIfRateLimited: undefined,
    endpointUrl: "https://api.airtable.com",
    apiKey: "keyLDoYXu5JweKZV2"
});

const main = async () => {

    const alpha = alphavantage({key: 'SUCANQHX4WM76OR8'});

    const base = airtable.base("appSBXXYsqN6exzLK");
    const records = await base('Stocks').select().all();
    const tickersAndIds = records.map((record) => {
        return { ticker: record.fields.Ticker, id: record.id}
    });
    const results = await Promise.all(tickersAndIds.map(async (tickerAndId) => {
        const quote = await alpha.data.quote(tickerAndId.ticker);
        const id = tickerAndId.id;
        return { quote, id };
    }));
    const prices = results.map((result) => {
        const object = result.quote["Global Quote"];
        return { Ticker: object["01. symbol"], Price: parseFloat(object["05. price"]), Id: result.id }
    });
    try {
        await Promise.all(prices.map(async (price) => {
            const record = await base('Stocks').update(price.Id, {Price: price.Price});
            console.log(record);
        }));
    } catch (e) {
        console.log(e);
    }
};

main().then(() => console.log("done"));
