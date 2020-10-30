const HOURS_TO_MS = 60 * 60 * 1000;

const scheduleTask = async (
    func: () => {},
    delayInHours: number
) => {
    await func();
    await setInterval(async () => {
        await func();
    }, delayInHours * HOURS_TO_MS);
};

export default scheduleTask;
