import dotenv from "dotenv";

dotenv.config();

const config = {
    airtable: {
        url: process.env.AIRTABLE_URL,
        apiKey: process.env.AIRTABLE_API_KEY,
        base: process.env.AIRTABLE_BASE
    },
    alphavantage: {
        apiKey: process.env.ALPHAVANTAGE_API_KEY
    }
};

export default config;