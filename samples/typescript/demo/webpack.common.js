const path = require ('path');

module.exports = {
	entry: "./src/app.ts",
	output: {
		path: path.resolve (__dirname, "dist"),
		filename: "app.js"
	},
	resolve: {
		alias: {
			"openfl": path.resolve (__dirname, "node_modules/openfl/lib/openfl"),
			"starling": path.resolve (__dirname, "node_modules/starling-framework/lib/starling")
		},
		extensions: [
			'.ts',
			'.tsx',
			'.js'
		]
	},
	module: {
		rules: [
			{
				test: /\.tsx?$/,
				loader: 'ts-loader'
			}
		]
	}
};