import alphavantageService from "./alphavantageService";
import airtableService from "./airtableService";
import {TickerAndRowId} from "../constants/types";
import coinMarketCapService from "./coinMarktetCapService";

export default class priceService {
    static setStockPrices = async (chunk: TickerAndRowId[]) => {
        const results = await Promise.all(chunk.map(async (tickerAndId) => {
            const quote = await alphavantageService.getQuote(tickerAndId.ticker);
            return {...quote, id: tickerAndId.id};
        }));
        await Promise.all(results.map(async (result) => {
            await airtableService.updateRecord('Stocks', result.id, { Price: result.price });
        }));
    };

    static setCryptoPrices = async () => {
        const records: TickerAndRowId[] = await airtableService.staticGetRecordsV2();
        const results = await Promise.all(records.map(async (tickerAndId) => {
            const quote = await coinMarketCapService.getQuote(tickerAndId.ticker);
            return { quote , id: tickerAndId.id};
        }));
        await Promise.all(results.map(async (result) => {
            await airtableService.updateRecord('Crypto', result.id, { Price: result.quote });
        }));
    };
}
