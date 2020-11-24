import config from "../setup/config";
import axios from "axios";

const { url, apiKey } = config.alphavantage;

export default class alphavantageService {
    static getQuote = async (symbol: string ): Promise<number> => {
        const response = await axios.get(`${url}/query`, {
            params: {
                function: 'GLOBAL_QUOTE',
                symbol,
                apikey: apiKey
            }
        });
        console.log(response);
        return parseFloat(response.data["Global Quote"]["05. price"]);
    }
}
