import moment from 'moment';



export default function waitUntil(func, wait) {
    let timeout;

    return function(...args) {
        const context = this;

        clearTimeout(timeout); // Clear the existing timer

        timeout = setTimeout(() => {
            func.apply(context, args); // Execute the function after the wait
        }, wait);
    };
}


export function injectScriptElement(src) {
    let tag = document.createElement('script');
    tag.src = src;

    let firstScriptTag = document.getElementsByTagName('script')[0];
    if (firstScriptTag == null) {
        (document.body || document.head).appendChild(tag);
    }
    else {
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
    }

    return tag;
}

export function formatTime(duration) {
    const Hr = Math.floor(duration / 3600);
    const Min = Math.floor((duration % 3600) / 60);
    const Sec = Math.floor(duration % 60);

    const paddedMin = Min.toString().padStart(2, '0');
    const paddedSec = Sec.toString().padStart(2, '0');

    if (Hr > 0) {
        return `${Hr}:${paddedMin}:${paddedSec}`;
    } else {
        return `${Min}:${paddedSec}`;
    }
}

//convert array in to array of arrays limited by size
export function chunkArray(array, size) {
    const chunks = [];
    for (let i = 0; i < array.length; i += size) {
        chunks.push(array.slice(i, i + size));
    }
    return chunks;
}

export function convertISODurationToSeconds(ISODuration) {
    if (typeof ISODuration === 'number' && !isNaN(ISODuration)) {
        return NaN;
    }
    return moment.duration(ISODuration).asSeconds();
}

