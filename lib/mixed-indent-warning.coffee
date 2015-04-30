MixedIndentWarningView = require './mixed-indent-warning-view'
IndentChecker = require '../lib/indent-checker'
{CompositeDisposable} = require 'atom'

module.exports = MixedIndentWarning =
  editor: null
  mixedIndentWarningView: null
  modalPanel: null
  subscriptions: null
  markers: []

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    @beginScans()

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'mixed-indent-warning:toggle': => @toggle()

    @subscriptions.add atom.commands.add 'atom-workspace', 'mixed-indent-warning:file': => @scanActiveFile()

  deactivate: ->
    @subscriptions.dispose()

  toggle: ->
    console.log 'MixedIndentWarning was toggled!'

  beginScans: ->
    atom.config.observe 'mixed-indent-warning.liveUpdate', (liveUpdate) =>
      if liveUpdate == 'enabled'
        atom.workspace.observeTextEditors (editor) =>
          @scanFile(editor)
          @subscriptions.add editor.onDidStopChanging =>
            @scanFile(editor)
      else
        @subscriptions.dispose()

  scanActiveFile: ->
    @scanFile(atom.workspace.getActiveTextEditor())

  clearMarkers: ->
    @markers.map (marker) ->
      marker.destroy()
    @markers = []

  scanFile: (editor) ->
    @clearMarkers()
    text = editor.getText()
    linesToDecorate = IndentChecker.getLinesWithLessCommonType(text)
    linesToDecorate.forEach (row) =>
      row = parseInt(row, 10) - 1
      marker = editor.markBufferRange([[row, 0], [row, Infinity]], invalidate: 'inside')
      marker.setProperties({MixedIndent: 'mixed-indent-incorrect'})
      @markers.push marker
      editor.decorateMarker(marker, type: 'line-number', class: "mixed-indent-incorrect")
