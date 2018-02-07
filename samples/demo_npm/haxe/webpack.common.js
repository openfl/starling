const CopyWebpackPlugin = require ('copy-webpack-plugin');
const WriteFilePlugin = require ('write-file-webpack-plugin');
const path = require ('path');

module.exports = {
	entry: "./build.hxml",
	output: {
		path: path.resolve (__dirname, "dist"),
		filename: "app.js",
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
		}
	},
	module: {
		rules: [
			{ test: /\.hxml$/, loader: 'haxe-loader' },
			{ test: /\.(jpe?g|gif|png|eot|svg|woff|ttf|ogg|wav|mp3|atf|fnt|xml|mp4)$/i, loader: "file-loader?name=assets/[name].[ext]" }
		]
	}
};