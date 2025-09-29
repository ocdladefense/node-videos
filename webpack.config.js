const path = require("path");
const webpack = require("webpack");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const CopyPlugin = require("copy-webpack-plugin");
const Dotenv = require('dotenv-webpack');

module.exports = env => {
    console.log(env);

    return {
        entry: {
            app: path.resolve(__dirname, "./src/js/index.js")
            // init_head: path.resolve(__dirname, "src/js/custom-elements.js")
        },
        snapshot: {
            managedPaths: ["/node_modules"],
            unmanagedPaths: ["/dev_modules"]
        },
        watchOptions: {
            followSymlinks: true
        },
        resolve: {
            symlinks: false,
            extensions: [".js", ".jsx"]
        },
        output: {
            path: path.resolve(__dirname, "dist"),
            publicPath: "/",
            filename: "[name].bundle.js",
            assetModuleFilename: "images/[name][ext]",
            clean: true
        },
        target: "web",
        devServer: {
            static: path.resolve(__dirname, "./src"),
            port: 8080,
            open: true,
            hot: true,
            compress: true,
            historyApiFallback: true
        },
        devtool: "source-map",
        module: {
            rules: [
                {
                    test: /\.(js|jsx)$/,
                    // exclude: /(node_modules)/,
                    use: {
                        loader: "babel-loader",
                        options: {
                            presets: [
                                ["@babel/preset-env", { modules: false }],
                                [
                                    "@babel/preset-react",
                                    {
                                        throwIfNamespace: false, // defaults to true
                                        runtime: "automatic", // defaults to classic
                                        targets: {
                                            chrome: "120"
                                        }
                                        // "importSource": "custom-jsx-library" // defaults to react (only in automatic runtime)
                                    }
                                ]
                            ]
                        }
                    }
                },
                {
                    test: /\.ts$/,
                    use: "ts-loader"
                },
                {
                    test: /\.css$/i,
                    use: ["style-loader", "css-loader", "postcss-loader"]
                },
                {
                    test: /\.(svg|eot|ttf|woff|woff2|webp|png|jpg|gif)$/i,
                    type: "asset/resource"
                },
                {
                    test: /\.xml$/i,
                    type: "asset/source"
                },
                {
                    test: /\.html$/i,
                    exclude: path.resolve(__dirname, "src/index.html"),
                    loader: "asset/source"
                }
            ]
        },
        plugins: [
            new Dotenv(),
            new HtmlWebpackPlugin({
                template: path.resolve(__dirname, "./src/index.html"),
                chunks: ["app"],
                inject: "body",
                filename: "index.html"
            }),
            new CopyPlugin({
                patterns: [
                    {
                        from: path.resolve(__dirname, "src/images"),
                        to: path.resolve(__dirname, "dist/images")
                    },
                    "src/.nojekyll",
                    "src/manifest.json",
                    "src/sw.js",
                    "src/robots.txt",
                    "src/.htaccess"
                ]
            })
        ]
    };
};
