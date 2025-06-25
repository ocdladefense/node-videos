

const KEY_SEPARATOR = ".";



export default class Cache {

    PREFIX;

    #enabled = true;

    constructor(prefix) {
        this.PREFIX = prefix
    }

    _key(key) {
        return [this.PREFIX, KEY_SEPARATOR, key].join("");
    }

    set(key, value) {
        localStorage.setItem(this._key(key), JSON.stringify(value));
    };

    get(key) {
        return JSON.parse(localStorage.getItem(this._key(key)));
    };

    clear() {
        localStorage.clear();
    };

    remove(key) {
        localStorage.removeItem(this._key(key));
    };

    hasKey(key) {
        return null != localStorage.getItem(this._key(key));
    };

    isEnabled() {
        return this.#enabled;
    };

    getCacheContents() {
        let cacheContents = {};
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            if (key.startsWith(this.PREFIX)) {
                cacheContents[key] = JSON.parse(localStorage.getItem(key));
            }
        }
        return cacheContents;
    };

    static getUncached(keys, cache1, cache2) {
        return keys.filter(id => !cache1.hasKey(id) || !cache2.hasKey(id));
    }
}


export function clearThumbCache() {
    const cache = new Cache();
    cache.clear();
    console.log("cache cleared.");
}
