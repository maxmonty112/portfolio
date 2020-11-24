import config from "../setup/config";
import axios from "axios";

const { url, base, apiKey } = config.airtable;

export default class airtableService {

    static updateRecord = async (table: string, id: string, record: any) =>
        await axios.patch(`${url}/${base}/${table}`, { records: [{ id, fields: record }]}, {
            headers: {
                Authorization: `Bearer ${apiKey}`,
                'Content-Type': 'application/json',
            }
        });

    static getRecords = async (table: string) => {
        const response = await axios.get(`${url}/${base}/${table}`, {
            headers: {
                Authorization: `Bearer ${apiKey}`,
            }
        });
        return response.data.records.map(record => ({ ticker: record.fields.Ticker, id: record.id }))
    }
}
