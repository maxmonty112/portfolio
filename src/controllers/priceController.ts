import winston from "winston";
import _ from "lodash";
import airtableService from "../services/airtableService";
import priceService from "../services/priceService";
import {TickerAndRowId} from "../constants/types";


export default class priceController {
    static updateStockPrices = async () => {
        winston.info('Stock price update started', { time: new Date() });
        const records: TickerAndRowId[] = await airtableService.getRecords('Stocks');
        const chunks: TickerAndRowId[][] = _.chunk(records, 5);
        let chunkNumber: number = 1;
        await Promise.all(chunks.map( (chunk) => {
            setTimeout(async () => {
                    winston.info(`Updating stocks: ${chunkNumber} / ${chunks.length}`, { tickers: chunk.map(x => x.ticker) });
                    await priceService.setStockPrices(chunk);
                },
                60000 * chunkNumber);
            chunkNumber++;
        }));
        winston.info('Stock price update complete', { time: new Date() });
    };

    static updateCryptoPrices = async () => {
        winston.info('Stock price update started', { time: new Date() });
        const records: TickerAndRowId[] = await airtableService.getRecords('Crypto');
    }
}
