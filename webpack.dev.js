const webpack = require ("webpack");
const { merge } = require ("webpack-merge");
const common = require ("./webpack.common.js");
const package = require ("./package.json");

var banner = "/*!\n"
 + " * Starling Framework v" + package.version + "\n"
 + " * https://gamua.com/starling/\n"
 + " * \n"
 + " * Copyright Gamua\n"
 + " * Released under the Simplified BSD license\n"
 + " */";

module.exports = merge (common, {
	mode: "development",
	output: {
		filename: "starling.js"
	},
	plugins: [
		new webpack.BannerPlugin ({
			banner: banner,
			raw: true,
			entryOnly: true
		})
	]
});