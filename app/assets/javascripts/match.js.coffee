Array.prototype.filter = (fn) ->
  r = []
  for item in this
    r.push(item) if fn(item)
  r
Array.prototype.iterateOver = (fn) ->
  r = []
  for item in this
    r.push fn(item)
  r
ko.forcibleComputed = (readFunc, context, options) ->
  trigger = ko.observable().extend({notify:'always'})
  target = ko.computed ->
    trigger()
    readFunc.call(context)
  , null, options
  target.evaluateImmediate = ->
    trigger.valueHasMutated()
  target
registrationViewModel = ->
  # fix the 'this' problem
  self = this

  # data
  self.invoices = ko.observableArray []
  self.active = ko.observable()
  self.paid = ko.computed ->
    self.invoices().filter( (item) ->
      item.paid
    ).sort( (left, right) ->
      right.shooters <= left.shooters
    )
  self.unpaid = ko.forcibleComputed ->
    self.invoices().filter( (item) ->
      !item.paid
    ).sort( (left, right) ->
      right.created_at <= left.created_at
    ).iterateOver (item) ->
      item.active = self.active() == item.id
      item
  # actions
  self.pay = (type, amount, item, event) ->
    $.post "/invoices/#{item.id}", {type: type, amount: amount, _method: 'put'}, (res) ->
      index = self.invoices.indexOf(item)
      self.invoices.splice index, 1, res
  self.resetPayments = (item) ->
    $.post "/invoices/#{item.id}/reset_payments", (res) ->
      index = self.invoices.indexOf(item)
      self.invoices.splice index, 1, res
  self.refresh = ->
    $.getJSON _match_path, self.invoices
  self.sign = (registration, invoice) ->
    $.getJSON "/registrations/"+registration.id+"/waiver", (res) ->
      index = self.invoices.indexOf(invoice)
      self.invoices.splice index, 1, res
  self.makeActive = (item) ->
    self.active item.id
    item.active = true
    self.unpaid.evaluateImmediate()


  # fix the coffee problem with the 'this' problem fix
  self
$ ->
  myViewModel = new registrationViewModel()
  ko.applyBindings myViewModel
  window.setInterval myViewModel.refresh, 5000
  myViewModel.refresh()
