import alphavantageService from "./alphavantageService";
import airtableService from "./airtableService";
import {TickerAndRowId} from "../constants/types";
import coinMarketCapService from "./coinMarktetCapService";
import winston from "winston";
import _ from "lodash";

const STOCKS_TABLE = 'Stocks';
const CRYPTO_TABLE = 'Crypto';

export default class priceService {
    static setStockPrices = async () => {
        const setPrices = async (chunk: TickerAndRowId[]) => {
            const results = await Promise.all(chunk.map(async (tickerAndId) => {
                const quote: number = await alphavantageService.getQuote(tickerAndId.ticker);
                return {quote, id: tickerAndId.id};
            }));
            await Promise.all(results.map(async (result) => {
                await airtableService.updateRecord(STOCKS_TABLE, result.id, { Price: result.quote });
            }));
            winston.info(`Stock prices updated`, { tickers: chunk.map(x => x.ticker), time: new Date() });
        };
        const records: TickerAndRowId[][] = _.chunk(await airtableService.getRecords(STOCKS_TABLE), 5);
        let delayMinutes = 1;
        await Promise.all(records.map( (chunk) => {
            setTimeout(async () => {
                    await setPrices(chunk);
                },
                60000 * delayMinutes);
            delayMinutes++;
        }));
        return records.length;
    };

    static setCryptoPrices = async () => {
        const records: TickerAndRowId[] = await airtableService.getRecords(CRYPTO_TABLE);
        const results = await Promise.all(records.map(async (tickerAndId) => {
            const quote = await coinMarketCapService.getQuote(tickerAndId.ticker);
            return { quote , id: tickerAndId.id};
        }));
        await Promise.all(results.map(async (result) => {
            await airtableService.updateRecord(CRYPTO_TABLE, result.id, { Price: result.quote });
        }));
        winston.info(`Crypto prices updated`, { tickers: records.map(x => x.ticker), time: new Date() });

    };
}
