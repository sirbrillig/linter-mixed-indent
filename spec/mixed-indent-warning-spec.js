'use babel'
/*eslint-env jasmine */
/*global atom, waitsForPromise */

import MixedIndent from '../lib/main'
import path from 'path'

// Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.

describe( 'MixedIndent', () => {
	const fixturePath = path.join( __dirname, 'fixtures' )

	describe( 'when the linter is triggered', () => {
		it( 'shows a message if there are two types of indentation in the file', () => {
			waitsForPromise( () => {
				return atom.workspace.open( path.join( fixturePath, 'more-spaces.txt' ) ).then( ( editor ) => {
					expect( editor.getText().length ).toBeGreaterThan( 1 )
					const messages = MixedIndent.provideLinter().lint( editor )
					expect( messages.length ).toEqual( 2 )
				} )
			} )
		} )

		it( 'does not show a message if all indentation in the file is the same', () => {
			waitsForPromise( () => {
				return atom.workspace.open( path.join( fixturePath, 'equal-tabs-spaces.txt' ) ).then( ( editor ) => {
					expect( editor.getText().length ).toBeGreaterThan( 1 )
					const messages = MixedIndent.provideLinter().lint( editor )
					expect( messages.length ).toEqual( 0 )
				} )
			} )
		} )

		it( 'shows a message next to lines with the less common indentation', () => {
			waitsForPromise( () => {
				return atom.workspace.open( path.join( fixturePath, 'more-spaces.txt' ) ).then( ( editor ) => {
					expect( editor.getText().length ).toBeGreaterThan( 1 )
					const messages = MixedIndent.provideLinter().lint( editor )
					expect( messages.map( ( message ) => message.range[0][0] ) ).toEqual( [ 4, 5 ] )
				} )
			} )
		} )
	} )
} )
