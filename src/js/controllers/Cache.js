export default class Cache {
    PREFIX;
    #enabled = true;

    constructor(prefix) {
        this.PREFIX = prefix
    }

    set(key, value) {
        if (this.#enabled === true) {
            localStorage.setItem(this.PREFIX + key, JSON.stringify(value));
        }
    };

    get(key) {
        return JSON.parse(localStorage.getItem(this.PREFIX + key));
    };

    clear() {
        localStorage.clear();
    };

    remove(key) {
        localStorage.removeItem(this.PREFIX + key);
    };

    hasKey(key) {
        return null == localStorage.getItem(this.PREFIX + key) ? false : true;
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
