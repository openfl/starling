const CopyWebpackPlugin = require ('copy-webpack-plugin');
const WriteFilePlugin = require ('write-file-webpack-plugin');
const path = require ('path');

module.exports = {
	entry: "./src/demo.ts",
	output: {
		path: path.resolve (__dirname, "dist"),
		filename: "app.js"
	},
	plugins: [
		new WriteFilePlugin (),
		new CopyWebpackPlugin ([
			{ from: path.resolve (__dirname, "../../demo/assets"), to: "assets" }
		]),
	],
	resolve: {
		alias: {
			"openfl": path.resolve (__dirname, "node_modules/openfl/lib/openfl"),
			"starling": path.resolve (__dirname, "node_modules/starling-framework/lib/starling")
		},
		extensions: [ '.ts', '.tsx', '.js' ]
	},
	module: {
		rules: [
			{ test: /\.tsx?$/, loader: 'ts-loader' }
		]
	}
};