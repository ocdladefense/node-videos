//import Controller from './Controller.js';

test('fetchLatLon returns accurate location data', async () => {
    const mockLatLon = { lat: 44.0185, lon: -123.0998 };

    const c = new Controller();
    const result = await c.fetchLatLon("97405");

    expect(result).toEqual(mockLatLon);

});

const buildGeoUrl = (zip) => `http://api.openweathermap.org/geo/1.0/zip?zip=${zip},US&${apikey}`;
API_KEY = "appid=f62d906d0cba21cc74c1fceb053bcb7e"

class Controller {
    async fetchLatLon(zip) {
        try {
            const response = await fetch(buildGeoUrl(zip));
            if (!response.ok) throw new Error("Failed to fetch geolocation data.");
            return await response.json();
        } catch (error) {
            console.error("Error in fetchLatLon:", error.message);
            return null;
        }
    }
}
