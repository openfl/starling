const path = require("path");
const CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = {
	entry: "./src/demo.ts",
	output: {
		path: path.resolve(__dirname, "dist"),
		filename: "app.js"
	},
	devtool: "source-map",
	resolve: {
		alias: {
			"openfl": path.resolve(__dirname, "node_modules/openfl/lib/openfl"),
			"starling": path.resolve(__dirname, "node_modules/starling-framework/lib/starling")
		},
		extensions: ['.tsx', '.ts', '.js']
	},
	module: {
		rules: [
			{
				test: /\.tsx?$/,
				loader: 'ts-loader'
			}
		]
	},
	plugins: [
		new CopyWebpackPlugin({
			patterns: [
				"public",
				{ from: path.resolve(__dirname, "../../demo/assets"), to: "assets" }
			]
		})
	]
};