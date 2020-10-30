import airtable from "airtable";
import config from "../setup/config";

airtable.configure({
    apiVersion: undefined, noRetryIfRateLimited: undefined,
    endpointUrl: config.airtable.url,
    apiKey: config.airtable.apiKey
});

const base = airtable.base(config.airtable.base);

export default class airtableService {

    static getRecords = async (tableName: string) => await base(tableName).select().all();

    static updateRecord = async (tableName: string, recordId: string, record: any) => await base(tableName).update(recordId, record);
}
