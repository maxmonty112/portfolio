import winston from "winston";
import setupLogger from "./setup/setupLogger";
import priceController from "./controllers/priceController";

const onServiceError = (error: Error) => {
    winston.error('Failed on start', error);
    process.exit(1);
};

// Catch unhandled promises
process.on('unhandledRejection', (reason: {} | null | undefined) => {
    winston.error('Unhandled promise exception', reason);
});

// Catch general exceptions
process.on('uncaughtException', (err: Error) => {
    winston.error(`uncaughtException: ${err.message}`, err);
    process.exit(1);
});

const init = async () => {
    setupLogger();
};

init().then(async () => {
    winston.info('Server started', { time: new Date() });
    await priceController.updateStockPrices(); // initial run
    await setInterval(priceController.updateStockPrices, 60000 * 5); // run again every 24 hours
}).catch(onServiceError);

