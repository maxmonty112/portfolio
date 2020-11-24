import winston from "winston";
import logger from "./setup/logger";
import priceController from "./controllers/priceController";
import schedule from "./setup/task";

const startError = (error: Error) => {
    winston.error('Failed on start', error);
    process.exit(1);
};

process.on('unhandledRejection', (reason: {} | null | undefined) => {
    winston.error('Unhandled promise exception', reason);
});

process.on('uncaughtException', (err: Error) => {
    winston.error(`uncaughtException: ${err.message}`, err);
    process.exit(1);
});

const init = async () => {
    logger();
};

init().then(async () => {
    winston.info('Server started', { time: new Date() });
    await schedule(priceController.updateCryptoPrices, 0, 24);
    await schedule(priceController.updateStockPrices, 1, 24);
}).catch(startError);

