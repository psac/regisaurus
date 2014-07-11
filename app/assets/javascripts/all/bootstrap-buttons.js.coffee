window.initButtons = ->
  $('[data-toggle="buttons-radio"]').each ->
    buttonGroup = $ this
    target = $ buttonGroup.data('target')
    buttons = buttonGroup.children()
    updateButton = ->
      button = $ this
      if typeof(button.data('value')) == 'undefined'
        value = button.text()
      else
        value = new String button.data('value')
        value = value.toString()
      button.removeClass 'active'
      button.addClass 'active' if value == target.val()
      button.on 'click', ->
        target.val(value).trigger 'change'
    buttons.each updateButton
    target.on 'change', updateButton
  $('[data-toggle="buttons-checkbox"]').each ->
    buttonGroup = $ this
    target = $ buttonGroup.data('target')
    buttons = buttonGroup.children()
    updateButton = ->
      button = $ this
      button.removeClass 'active'
      button.addClass 'active' if button.text() == target.val()
      button.on 'click', ->
        target.val(button.text()).trigger 'change'
    buttons.each updateButton
    target.on 'change', updateButton
$ initButtons
