import winston from 'winston';
import appRoot from 'app-root-path';

const baseJsonFormat = winston.format.combine(
    winston.format.timestamp(),
    winston.format.metadata({ fillExcept: ['message', 'level', 'timestamp', 'label'] }),
    winston.format.json(),
);

const consoleFormat = winston.format.combine(
    winston.format.timestamp(),
    winston.format.metadata({
        fillExcept: ['message', 'level', 'timestamp', 'label'],
    }),
    winston.format.printf(
        ({
             level, message, timestamp, metadata,
         }) => `${timestamp} [${level.toUpperCase()}]: ${message}. Metadata: ${JSON.stringify(
            metadata,
        )}`,
    ),
);

const setupLogger = () => {
    winston.add(
        new winston.transports.File({
            filename: `${appRoot}/logs/app.log`,
            handleExceptions: true,
            level: 'info',
            maxFiles: 15,
            maxsize: 5242880,
            format: baseJsonFormat,
        }),
    );

    winston.add(
        new winston.transports.File({
            filename: `${appRoot}/logs/app.error.log`,
            handleExceptions: true,
            level: 'error',
            maxFiles: 15,
            maxsize: 5242880,
            format: baseJsonFormat,
        }),
    );

    winston.add(
        new winston.transports.Console({
            level: 'info',
            handleExceptions: true,
            format: consoleFormat,
        }),
    );
};

export default setupLogger;
