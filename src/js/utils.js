

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
