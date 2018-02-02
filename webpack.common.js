const path = require ("path");

module.exports = {
	entry: "./lib/starling/index.js",
	devtool: "source-map",
	output: {
		path: path.resolve (__dirname, "dist"),
		library: 'starling',
		libraryTarget: 'umd'
	},
	resolve: {
		alias: {
			"openfl": path.resolve (__dirname, "node_modules/openfl/lib/openfl")
		}
	}
};