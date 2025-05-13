export default class Time {

    static parseTime(videoDuration) {
        const Hr = Math.floor(videoDuration / 3600);
        const Min = Math.floor((videoDuration % 3600) / 60);
        const Sec = Math.floor(videoDuration % 60);

        const paddedMin = Min.toString().padStart(2, '0');
        const paddedSec = Sec.toString().padStart(2, '0');

        if (Hr > 0) {
            return `${Hr}:${paddedMin}:${paddedSec}`;
        } else {
            return `${Min}:${paddedSec}`;
        }
    }
}
