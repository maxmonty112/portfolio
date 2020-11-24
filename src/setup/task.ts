const hoursToMs = (hours: number) => hours * 60 * 60 * 1000;
const minsToMs = (minutes: number) => minutes * 60 * 1000;

const schedule = async (
    func: () => {},
    minutes: number,
    hours: number
) => {
    setTimeout(func, minsToMs(minutes));
    setInterval(() => {
        func();
    },  hoursToMs(hours));
};

export default schedule;
