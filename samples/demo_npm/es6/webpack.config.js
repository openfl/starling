const path = require("path");
const CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = {
	entry: "./src/demo.js",
	output: {
		path: path.resolve(__dirname, "dist"),
		filename: "app.js"
	},
	devtool: "source-map",
	resolve: {
		alias: {
			"openfl": path.resolve(__dirname, "node_modules/openfl/lib/openfl"),
			"starling": path.resolve(__dirname, "node_modules/starling-framework/lib/starling")
		}
	},
	module: {
		rules: [
			{ test: /\.js$/, exclude: /node_modules/, loader: "babel-loader" }
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