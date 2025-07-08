

const KEY_SEPARATOR = ".";



export default class Cache {

    #prefix;


    constructor(prefix) {
        this.#prefix = prefix;
    }

    _key(key) {
        return [this.#prefix, KEY_SEPARATOR, key].join("");
    }

    set(key, value) {
        localStorage.setItem(this._key(key), JSON.stringify(value));
    };

    get(key) {
        return JSON.parse(localStorage.getItem(this._key(key)));
    };

    clear() {
        localStorage.clear(); // yikes, no... this clears everything.
    };

    remove(key) {
        localStorage.removeItem(this._key(key));
    };

    hasKey(key) {
        return null != localStorage.getItem(this._key(key));
    };




    values() {

        return Cache.getCacheContents(this.#prefix);
    }


    static getCacheContents(prefix) {
        let index = {};
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            if (key.startsWith(prefix)) {
                index[key] = localStorage.getItem(key);
            }
        }

        return index;
    }

    static getUncached(keys, cache1, cache2) {
        return keys.filter(id => !cache1.hasKey(id) || !cache2.hasKey(id));
    }
}


export function clearThumbCache() {
    const cache = new Cache();
    cache.clear();
    console.log("cache cleared.");
}
