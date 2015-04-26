MixedIndentWarning = require '../lib/mixed-indent-warning'
MixedIndentWarningView = require '../lib/mixed-indent-warning-view'

IndentChecker = require '../lib/indent-checker'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "IndentChecker", ->
  describe ".getLineType()", ->
    it "returns 'spaces' when the input starts with spaces", ->
      expect( IndentChecker.getLineType( "  foo" ) ).toBe( 'spaces' )

    it "returns 'tabs' when the input starts with tabs", ->
      expect( IndentChecker.getLineType( "\tfoo" ) ).toBe( 'tabs' )

  describe ".getLinesByType()", ->
    it "returns an object with keys for each type found", ->
      input = "  foobar1\n  foobar2\n\tfoobar3\n  foobar4"
      types = IndentChecker.getLinesByType( input )
      expect( Object.keys( types ).length ).toBe( 2 )

    it "returns a list of lines for each type", ->
      input = "  foobar1\n  foobar2\n\tfoobar3\n  foobar4"
      types = IndentChecker.getLinesByType( input )
      expect( types[ 'spaces' ].length ).toBe( 3 )
      expect( types[ 'tabs' ].length ).toBe( 1 )

  describe ".getMostCommonIndentType()", ->
    it "returns 'spaces' when the input contains more space indentations than tabs", ->
      input = "  foobar1\n  foobar2\n\tfoobar3\n  foobar4"
      expect( IndentChecker.getMostCommonIndentType(input) ).toBe( 'spaces' )

    it "returns 'tabs' when the input contains more tabs indentations than spaces", ->
      input = "\tfoobar1\n\tfoobar2\n  foobar3\n\tfoobar4"
      expect( IndentChecker.getMostCommonIndentType(input) ).toBe( 'tabs' )

    it "returns 'spaces' when the input contains equal tab and space indentation", ->
      input = "\tfoobar1\n  foobar2\n\tfoobar3\n  foobar4"
      expect( IndentChecker.getMostCommonIndentType(input) ).toBe( 'spaces' )

  describe ".getLinesWithLessCommonType()", ->
    it "returns an array of line numbers with the less-common indentation type from the input", ->
      input = "  foobar1\n  foobar2\n\tfoobar3\n  foobar4"
      expect( IndentChecker.getLinesWithLessCommonType(input) ).toEqual([3])

    it "returns an empty array if the input is entirely one type", ->
      input = "  foobar1\n  foobar2\n  foobar3\n  foobar4"
      expect( IndentChecker.getLinesWithLessCommonType(input) ).toEqual([])


describe "MixedIndentWarning", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('mixed-indent-warning')

  describe "when the mixed-indent-warning:file event is triggered", ->
    it "shows a decoration if there are two types of indentation in the file", ->

      waitsForPromise ->
        atom.workspace.open('./fixtures/more-spaces.txt').then (editor) ->
          atom.commands.dispatch workspaceElement, 'mixed-indent-warning:file'
          warningLine = workspaceElement.querySelector('.mixed-indent-incorrect')
          expect(warningLine).toExist()

    xit "does not show a decoration if all indentation in the file is the same"

    xit "shows a decoration next to lines with the less common indentation"

  describe "when the mixed-indent-warning:toggle event is triggered", ->
    xit "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.mixed-indent-warning')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'mixed-indent-warning:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.mixed-indent-warning')).toExist()

        mixedIndentWarningElement = workspaceElement.querySelector('.mixed-indent-warning')
        expect(mixedIndentWarningElement).toExist()

        mixedIndentWarningPanel = atom.workspace.panelForItem(mixedIndentWarningElement)
        expect(mixedIndentWarningPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'mixed-indent-warning:toggle'
        expect(mixedIndentWarningPanel.isVisible()).toBe false

    xit "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.mixed-indent-warning')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'mixed-indent-warning:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        mixedIndentWarningElement = workspaceElement.querySelector('.mixed-indent-warning')
        expect(mixedIndentWarningElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'mixed-indent-warning:toggle'
        expect(mixedIndentWarningElement).not.toBeVisible()
