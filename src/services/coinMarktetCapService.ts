import config from "../setup/config";
import winston from "winston";
import axios from "axios";

const { url, apiKey } = config.coinMarketCap;
export default class coinMarketCapService {
    static getQuote = async (ticker: string): Promise<number> => {
        const params = { symbol: ticker };
        const headers = { 'X-CMC_PRO_API_KEY': apiKey };
        return axios.get(`${url}/v1/cryptocurrency/quotes/latest`, { headers, params }).then(response =>
            response.data.data[ticker].quote.USD.price
        ).catch(e => winston.error(e));
    }
}
