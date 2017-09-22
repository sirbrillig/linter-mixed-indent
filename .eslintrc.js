module.exports = {
	plugins: [
		'prettier',
	],
	'extends': [
		'eslint:recommended',
		'prettier',
	],
	parserOptions: {
		ecmaVersion: 2017,
		sourceType: 'module',
		ecmaFeatures: {
			modules: true,
		},
	},
	rules: {
		'prettier/prettier': [ 'error', {
				'singleQuote': true,
				trailingComma: 'all',
			} ]
	},
};
