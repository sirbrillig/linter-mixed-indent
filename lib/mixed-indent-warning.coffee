MixedIndentWarningView = require './mixed-indent-warning-view'
{CompositeDisposable} = require 'atom'

module.exports = MixedIndentWarning =
  editor: null
  mixedIndentWarningView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @mixedIndentWarningView = new MixedIndentWarningView(state.mixedIndentWarningViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @mixedIndentWarningView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'mixed-indent-warning:toggle': => @toggle()

    @subscriptions.add atom.commands.add 'atom-workspace', 'mixed-indent-warning:file': => @file()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @mixedIndentWarningView.destroy()

  serialize: ->
    mixedIndentWarningViewState: @mixedIndentWarningView.serialize()

  toggle: ->
    console.log 'MixedIndentWarning was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  file: ->
    console.log 'Scanning the file...'
    true
