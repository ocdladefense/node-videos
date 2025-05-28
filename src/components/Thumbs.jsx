import React from 'react';

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
