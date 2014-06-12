module.exports =
  markerType: 'highlight'

  activate: (state) ->
    setImmediate =>
      @run()

  deactivate: ->

  serialize: ->

  run: ->
    editor = atom.workspace.getActiveEditor()
    buffer = editor.getBuffer()

    singleLineRow = null
    for i in [0...buffer.getLineCount()]
      if buffer.lineForRow(i).length >= 10
        singleLineRow = i
        break

    if singleLineRow?
      range = [[singleLineRow, 2], [singleLineRow, buffer.lineForRow(singleLineRow).length - 3]]
      console.log 'adding single line to range', range
      marker = @createMarker(editor, range)
      editor.addDecorationForMarker(marker, {type: @markerType, class: 'sweet-view'})

    multiLineStartRow = null
    multiLineEndRow = null
    for i in [i+3...buffer.getLineCount()]
      if buffer.lineForRow(i).length >= 10
        # more than 2 lines
        if multiLineStartRow? and multiLineStartRow + 1 < i
          multiLineEndRow = i
          break
        else if not multiLineStartRow?
          multiLineStartRow = i

    if multiLineStartRow? and multiLineEndRow?
      range = [[multiLineStartRow, 2], [multiLineEndRow, buffer.lineForRow(multiLineEndRow).length - 3]]
      console.log 'adding multiline to range', range
      marker = @createMarker(editor, range)
      editor.addDecorationForMarker(marker, {type: @markerType, class: 'sweet-view'})

  createMarker: (editor, range) ->
    editor.displayBuffer.markBufferRange(range, class: 'test-highlight', invalidate: 'inside')
