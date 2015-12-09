'use babel'

import IndentChecker from '../lib/indent-checker'
import Linter from 'atom-linter'

export default {
	config: {},

	activate() {
	},

	deactivate() {
	},

	scanFile( textEditor ) {
		const text = textEditor.getText()
		const linesToDecorate = IndentChecker.getLinesWithLessCommonType( text )
		return linesToDecorate.map( line => {
			return {
				type: 'Warning',
				text: 'Indentation different from rest of file',
				range: Linter.rangeFromLineNumber( textEditor, line - 1 ),
				filePath: textEditor.getPath()
			}
		} )
	},

	provideLinter() {
		return {
			name: 'MixedIndentWarning',
			grammarScopes: [ '*' ],
			scope: 'file',
			lintOnFly: true,
			lint: this.scanFile
		}
	}
}
