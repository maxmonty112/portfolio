import CoinMarketCap from "coinmarketcap-api";
import config from "../setup/config";

const client = new CoinMarketCap(config.coinMarketCap.apiKey);

export default class coinMarketCapService {
    static getPrices = async () => {


    }
}
