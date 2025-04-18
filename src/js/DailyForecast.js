

export default class DailyForecast {

    static MORNING = 6;
    static NOON = 12;
    static EVENING = 18;
    static NIGHT = 22;


    constructor(data) {

        this.data = data;
    }




    getLow() {

        let lowTemps = this.data.map((day) => {
            return day.main.temp_min;
        });

        return Math.min(...lowTemps);
    }


    getHigh() {

        let highTemps = this.data.map((day) => {
            return day.main.temp_max;
        });

        return Math.max(...highTemps);
    }


    // We need an algorithm to find one or more data points that meet some creiteria around timestamp
    // For example, if the timestamp is 12:00, we want to find the data points that are closest to 12:00.
    // make a decision about how to determine the morning hour.
    getPartOfDay(part) {
        let dataLength = this.data.length;
        for (let i = 0; i < dataLength; i++) {
            let dt = new Date(this.data[i].dt * 1000);
            dt = dt.getHours();
            if (dt >= part) {
                return dt;
            }
        }
    }

    getDataByHour(h1) {
        return this.data.filter((h) => {
            let dt = new Date(h.dt * 1000);
            let hours = dt.getHours();

            return hours === h1;
        });
    }

    getFormattedDate() {
        return `${new Date(this.data[0].dt * 1000).getMonth() + 1}/${new Date(this.data[0].dt * 1000).getDate()}`;
    }



    // These methods need work.
    getMorningTemp() {

        // Get any data points that are representative of "morning" (6am)
        let data = this.getDataByHour(this.getPartOfDay(DailyForecast.MORNING));
        
        return data.main.temp;
    }


    getDayTemp() {
        // Get any data points that are representative of "morning" (6am)
        let data = this.getDataByHour(this.getPartOfDay(DailyForecast.NOON));
        
        return data.main.temp;

        
    }
    getEveningTemp() {
        // Get any data points that are representative of "morning" (6am)
        let data = this.getDataByHour(this.getPartOfDay(DailyForecast.EVENING));

        return data.main.temp;
    }


    getNightTemp() {
        // Get any data points that are representative of "morning" (6am)
        let data = this.getDataByHour(this.getPartOfDay(DailyForecast.NIGHT));

        return data.main.temp;
    }


    getDescription() {
        let data = this.getDataByHour(this.getPartOfDay(NOON))
        return data.weather[0].description
    }
    getIcon() {
        let data = this.getDataByHour(this.getPartOfDay(NOON))
        return data.weather[0].icon;
    }
    getPressure() {
        let data = this.getDataByHour(this.getPartOfDay(NOON))
        return data.main.pressure;
    }
    getWind() {
        let data = this.getDataByHour(this.getPartOfDay(NOON))
        return data.wind.speed;
    }
    getHumidity() {
        let data = this.getDataByHour(this.getPartOfDay(NOON))
        return data.main.humidity;
    }



}
