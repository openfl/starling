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
	},
	externals: [
		function (context, request, callback) {
			if (/^openfl\//.test (request)) {
				return callback (null, {
					amd: request,
					root: request.split ("/"),
					commonjs: request,
					commonjs2: request
				});
			}
			callback ();
		}
	]
};