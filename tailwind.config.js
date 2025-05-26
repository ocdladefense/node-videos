/** @type {import('tailwindcss').Config} */

const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
    content: [
        "./src/**/*.{html,js,jsx}",
        "./dev_modules/@ocdla/global-components/**/*.{html,js,jsx}",
        "./node_modules/@ocdla/global-components/**/*.{html,js,jsx}",
        "./node_modules/@themes/active/**/*.{html,js,jsx}",
    ],
    theme: {
        screens: {
            'phone': '320px',
            'tablet-portrait': '480px',
            'tablet': '800px',
            'laptop': '1024px',
            'desktop': '1280px'
        },
        extend: {
            fontFamily: {
                sans: ["Open Sans", ...defaultTheme.fontFamily.sans],
                serif: ["Tienne", ...defaultTheme.fontFamily.serif],
                "default-paragraph": ["Tienne"],
                "default-heading": ["Open Sans", ...defaultTheme.fontFamily.sans],
                smoothy: ["Smoothy Cursive", ...defaultTheme.fontFamily.sans],
                marketing: ["Marketing", ...defaultTheme.fontFamily.sans]
            },
            colors: {
                "wb-brown": "#794850", // ferra
                "menu": "rgba(255, 255, 255, 0.6)",
                "wb-cordovan": "#7D4F52",
                "wb-red": "#D0375C", // brick red
                "wb-lime": "#B5E179", // yellow green
                "wb-blue": "#394657", // oxford blue
                "wb-orange": "#F68544", // jaffa
                "wb-black": "rgb(24 24 27)",
                "default-paragraph-black": "rgba(200, 200, 200, 0.8)",
                "wb-gray": "#F5F6F8",
                "wb-white": "rgb(255,255,255)",
                "wb-stone": "rgb(168 162 158)",
                "burst": "rgb(109,67,83)",
                "burst-light": "rgb(248,224,170)",
                "burst-dark": "rgb(219,136,70)",
                "plush": "rgb(43,61,69)",
                "bonfire": "rgb(40,48,33)",
                "sunshine": "rgb(247,224,170)",
                "default-background": "rgb(247,224,170)",
                "sunshine-dark": "rgb(158,50,48)"
            }
        }
    },
    plugins: [require("@tailwindcss/forms")]
};
