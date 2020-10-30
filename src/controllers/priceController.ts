import winston from "winston";
import _ from "lodash";
import airtableService from "../services/airtableService";
import priceService, {TickerAndRowId} from "../services/priceService";


export default class priceController {
    static updateStockPrices = async () => {
        winston.info('Stock price update started', { time: new Date() });
        const records: TickerAndRowId[] = await airtableService.getRecords('Stocks').then((response) => {
            return response.map(record => ({ ticker: record.fields.Ticker, id: record.id }))
        });
        const chunks: TickerAndRowId[][] = _.chunk(records, 5);
        let firstCall = true;
        await Promise.all(chunks.map(async (chunk) => {
            const tickers = chunk.map(x => x.ticker);
            if (firstCall) {
                firstCall = false;
                winston.info('Stocks updated. First chunk.', { tickers });
                await priceService.setPrices(chunk);
            } else {
                await setTimeout(async () => {
                        winston.info(`Chunk X`, {tickers});
                        await priceService.setPrices(chunk);
                    },
                    60000);
            }
        }));
    }
}
