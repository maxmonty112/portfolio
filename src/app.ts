import winston from "winston";
import setupLogger from "./setup/setupLogger";
import priceController from "./controllers/priceController";
import scheduleTask from "./setup/scheduledTask";

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
    await scheduleTask(priceController.updateCryptoPrices, 24);
}).catch(onServiceError);

