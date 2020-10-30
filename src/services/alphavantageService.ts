import alphavantage from "alphavantage";
import config from "../setup/config";

const alpha = alphavantage({key: config.alphavantage.apiKey});

export default class alphavantageService {
    static getQuote = async (ticker: string ): Promise<{ ticker: string, price: number }> => {
        const quote = await alpha.data.quote(ticker).then((response) => response["Global Quote"]);
        return { ticker: quote["01. symbol"], price: parseFloat(quote["05. price"]) }
    }
}
