'use babel'

import { lint } from 'mixedindentlint'
import LinterHelpers from 'atom-linter'

export default {
	config: {},

	activate() {
	},

	deactivate() {
	},

	scanFile( textEditor ) {
		const text = textEditor.getText()
		const linesToDecorate = lint( text )
		return linesToDecorate.map( line => {
			return {
				type: 'Warning',
				text: 'Indentation different from rest of file',
				range: LinterHelpers.rangeFromLineNumber( textEditor, line - 1 ),
				filePath: textEditor.getPath()
			}
		} )
	},

	provideLinter() {
		return {
			name: 'MixedIndent',
			grammarScopes: [ '*' ],
			scope: 'file',
			lintOnFly: true,
			lint: this.scanFile
		}
	}
}
