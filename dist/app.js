"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const alphavantage_1 = __importDefault(require("alphavantage"));
const airtable_1 = __importDefault(require("airtable"));
airtable_1.default.configure({
    apiVersion: undefined, noRetryIfRateLimited: undefined,
    endpointUrl: "https://api.airtable.com",
    apiKey: "keyLDoYXu5JweKZV2"
});
const main = () => __awaiter(void 0, void 0, void 0, function* () {
    const alpha = alphavantage_1.default({ key: 'SUCANQHX4WM76OR8' });
    const base = airtable_1.default.base("appSBXXYsqN6exzLK");
    const records = yield base('Stocks').select().all();
    const tickersAndIds = records.map((record) => {
        return { ticker: record.fields.Ticker, id: record.id };
    });
    const results = yield Promise.all(tickersAndIds.map((tickerAndId) => __awaiter(void 0, void 0, void 0, function* () {
        const quote = yield alpha.data.quote(tickerAndId.ticker);
        const id = tickerAndId.id;
        return { quote, id };
    })));
    const prices = results.map((result) => {
        const object = result.quote["Global Quote"];
        return { Ticker: object["01. symbol"], Price: parseFloat(object["05. price"]), Id: result.id };
    });
    try {
        yield Promise.all(prices.map((price) => __awaiter(void 0, void 0, void 0, function* () {
            const record = yield base('Stocks').update(price.Id, { Price: price.Price });
            console.log(record);
        })));
    }
    catch (e) {
        console.log(e);
    }
});
main().then(() => console.log("done"));
//# sourceMappingURL=app.js.map