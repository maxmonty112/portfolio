import priceService from "../services/priceService";
import winston from "winston";

export default class priceController {
    static updateStockPrices = async () => {
        winston.info('Stock price update job started', {time: new Date()});
        const minutesUntilCompletion: number = await priceService.setStockPrices();
        await setTimeout(() => winston.info('Stock price update job ended', {time: new Date()}), minutesUntilCompletion * 65000);

    };
    static updateCryptoPrices = async () => {
        winston.info('Crypto price update job started', {time: new Date()});
        await priceService.setCryptoPrices();
        winston.info('Crypto price update job ended', {time: new Date()});
    };
}
