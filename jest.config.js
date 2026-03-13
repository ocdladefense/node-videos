export default {

    testEnvironment: 'jsdom',

    setupFilesAfterEnv: ["<rootDir>/jest.setup.js"],

    testEnvironmentOptions: {
        url: 'http://localhost',
        userAgent: 'Custom User Agent',
    },

    moduleFileExtensions: ['js', 'jsx'],
    moduleDirectories: ['node_modules', 'bower_components', 'shared'],

    moduleNameMapper: {
        '\\.(css|less)$': '<rootDir>/__mocks__/styleMock.js',
        '\\.(gif|ttf|eot|svg)$': '<rootDir>/__mocks__/fileMock.js',
    },

    transform: {
        "^.+\\.js$": "babel-jest",
    },
};
