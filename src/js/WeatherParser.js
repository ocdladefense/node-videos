import DailyForecast from "./DailyForecast";

export default class WeatherParser {
    grouped;
    finalArray;
    constructor(forecast) {
        function GroupBy(obj) {

            //translate dt to JS date
            let dt = new Date(obj.dt * 1000);

            //make a date with format month.day
            let month = dt.getMonth();
            let day = dt.getDate();
            let key = month + "." + day;

            return key;
        }
        this.grouped = Object.groupBy(forecast, GroupBy);

        this.finalArray = [];
        for (let day in this.grouped) {
            let foo = this.grouped[day];
            this.finalArray.push(new DailyForecast(foo));
        }
    }
}
