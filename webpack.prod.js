const webpack = require ("webpack");
const merge = require ("webpack-merge");
const UglifyJSPlugin = require ("uglifyjs-webpack-plugin");
const common = require ("./webpack.common.js");
const package = require ("./package.json");

module.exports = merge (common, {
	output: {
		filename: "starling.min.js"
	},
	plugins: [
		new UglifyJSPlugin ({
			sourceMap: true,
			uglifyOptions: {
				// warnings: true
			}
		}),
		new webpack.BannerPlugin ({
			banner: "/*! Starling Framework v" + package.version + " | Simplified BSD (c) Gamua | gamua.com/starling */",
			raw: true,
			entryOnly: true
		}),
		new webpack.DefinePlugin ({
			"process.env.NODE_ENV": JSON.stringify ("production")
		})
	]
});