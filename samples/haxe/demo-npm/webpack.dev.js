const merge = require ('webpack-merge');
const common = require ('./webpack.common.js');

module.exports = merge (common, {
	devServer: {
		contentBase: './dist'
	},
	devtool: "inline-source-map",
});