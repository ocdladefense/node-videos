import React from 'react';
//import forecast from '../data/data.json';
/*

/// Components:
- App (Master Component);                                                                   Check[X]
- ZipCodeInput(A text input for the user to enter a zip code)                               Check[X]
- WeatherListItem  (A button that summarizes the high/low for a day; it's also selectable)   Check[]
- WeatherList (Parent component that displays all of the WeatherListItems)                  Check[]
- DailyForecastDetails currentday(Show all of the important weather for a given day)                  Check[]
*/



export default function Thumbs({ urls }) {
    return (

    <div className="app">
    <h2>Here is the list of thumbnails!</h2>

    <div>
        {urls.map(url => <img src={url} />)}
    </div>

    </div>
    )
}

// export default function WeatherListItem() {}
// export default function WeatherList() {}
// export default function DailyForecastDetails() {}


