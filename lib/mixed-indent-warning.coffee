MixedIndentWarningView = require './mixed-indent-warning-view'
IndentChecker = require '../lib/indent-checker'
{CompositeDisposable} = require 'atom'

module.exports = MixedIndentWarning =
  editor: null
  mixedIndentWarningView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'mixed-indent-warning:toggle': => @toggle()

    @subscriptions.add atom.commands.add 'atom-workspace', 'mixed-indent-warning:file': => @scanFile()

  deactivate: ->
    @subscriptions.dispose()

  toggle: ->
    console.log 'MixedIndentWarning was toggled!'

  scanFile: ->
    atom.workspace.observeTextEditors (editor) ->
      text = editor.getText()
      linesToDecorate = IndentChecker.getLinesWithLessCommonType(text)
      linesToDecorate.forEach (row) ->
        row = parseInt(row, 10) - 1
        marker = editor.markBufferRange([[row, 0], [row, Infinity]], invalidate: 'inside')
        marker.setProperties({MixedIndent: 'mixed-indent-incorrect'})
        editor.decorateMarker(marker, type: 'line-number', class: "mixed-indent-incorrect")
