MixedIndentWarning = require '../lib/main'
path = require 'path'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "MixedIndentWarning", ->
  [workspaceElement, activationPromise] = []
  fixturePath = path.join(__dirname, 'fixtures')

  beforeEach ->
    activationPromise = atom.packages.activatePackage('mixed-indent-warning')

  describe "when the linter is triggered", ->
    it "shows a message if there are two types of indentation in the file", ->
      waitsForPromise ->
        atom.workspace.open(path.join(fixturePath, 'more-spaces.txt')).then (editor) ->
          expect(editor.getText().length).toBeGreaterThan 1
          messages = MixedIndentWarning.provideLinter().lint( editor )
          expect( messages.length ).toEqual 2

    it "does not show a message if all indentation in the file is the same", ->
      waitsForPromise ->
        atom.workspace.open(path.join(fixturePath, 'equal-tabs-spaces.txt')).then (editor) ->
          expect(editor.getText().length).toBeGreaterThan 1
          messages = MixedIndentWarning.provideLinter().lint( editor )
          expect( messages.length ).toEqual 0

    it "shows a message next to lines with the less common indentation", ->
      waitsForPromise ->
        atom.workspace.open(path.join(fixturePath, 'more-spaces.txt')).then (editor) ->
          expect(editor.getText().length).toBeGreaterThan 1
          messages = MixedIndentWarning.provideLinter().lint( editor )
          expect( messages.map( ( message ) => message.range[0][0] ) ).toEqual( [ 4, 5 ] )
