const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const webpack = require('webpack');
const DEV = process.env.NODE_ENV !== 'production';
const appDirectory = path.resolve(__dirname);
const alias = {
    'react-native$': 'react-native-web',
    'react-router-native$': 'react-router-dom'
};
const dist = path.resolve(appDirectory, './web/dist');
const static = path.resolve(dist, 'public');

    const babelLoaderConfiguration = {
        test: /\.js$/,
        include: [
            path.resolve(appDirectory, 'index.web.client.js'),
            path.resolve(appDirectory, 'src'),
            path.resolve(appDirectory, 'node_modules/react-native-paper'),
            path.resolve(appDirectory, 'node_modules/react-native-vector-icons'),
            path.resolve(appDirectory, 'node_modules/react-native-safe-area-view'),
            path.resolve(appDirectory, 'node_modules/react-native-platform-touchable'),
        ],
        use: {
            loader: 'babel-loader',
            query: {
                babelrc: false,
                plugins: ['react-native-web'],
                presets: ['react-native'],
            },
        },
    }

    const imageLoaderConfiguration = {
        test: /\.(gif|jpe?g|png|svg)$/,
        include: [
            path.resolve(appDirectory, 'public/images/assets')
        ],
        use: {
            loader: 'file-loader',
            options: {
                name: 'images/assets/[name].[ext]',
                emitFile: true
            },
        },
    }

    const imageLoaderConfiguration2 = {
        test: /\.(gif|jpe?g|png|svg)$/,
        include: [
            path.resolve(appDirectory, 'node_modules/react-native-calendars/src/calendar/img')
        ],
        use: {
            loader: 'file-loader',
            options: {
                name: 'images/calendar/[name].[ext]',
                emitFile: true
            },
        },
    }

    const ttfLoaderConfiguration = {
        test: /\.ttf$/,
        include: [
            path.resolve(appDirectory, 'public/fonts')
        ],
        use: [
            {
                loader: 'file-loader',
                options: {
                    name: 'fonts/[hash].[ext]',
                    emitFile: true
                },
            },
        ]
    }

module.exports = {
    mode: process.env.NODE_ENV,
    target: 'web',
    name: 'client',
    devtool: DEV ? 'cheap-module-source-map' : 'source-map',
    entry: path.resolve(appDirectory, 'index.web.client.js'),
    resolve: {
        alias: alias
    },
    output: {
        path: static,
        publicPath: '/',
        filename: 'bundle.js'
    },
    plugins: [
        new CopyWebpackPlugin([
            {
                from: path.resolve(appDirectory, 'public'),
                to: static,
                ignore: ['.DS_Store', 'fonts/*', 'images/**/*']
            }
        ])
    ],
    module: {
        rules: [
            babelLoaderConfiguration,
            imageLoaderConfiguration,
            imageLoaderConfiguration2,
            ttfLoaderConfiguration
        ]
    }
}


