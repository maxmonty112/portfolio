import airtable from "airtable";
import config from "../setup/config";
import axios from "axios";

airtable.configure({
    apiVersion: undefined, noRetryIfRateLimited: undefined,
    endpointUrl: config.airtable.url,
    apiKey: config.airtable.apiKey
});

const base = airtable.base(config.airtable.base);

export default class airtableService {

    static getRecords = async (tableName: string) => {
        const response = await base(tableName).select().all();
        return response.map(record => ({ ticker: record.fields.Ticker, id: record.id }))
    };

    static updateRecord = async (tableName: string, recordId: string, record: any) => await base(tableName).update(recordId, record);

    static staticGetRecordsV2 = async () => {
        const response = await axios.get('https://api.airtable.com/v0/appSBXXYsqN6exzLK/Crypto', {
            headers: {
                Authorization: 'Bearer keyLDoYXu5JweKZV2',
            }
        });
        return response.data.records.map(record => ({ ticker: record.fields.Ticker, id: record.id }))
    }
}
