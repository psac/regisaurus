app = angular.module 'registrations', ['ngRoute', 'ngResource']

app.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/invoice/:id',
    template: JST['registrations/templates/show']
    controller: 'InvoiceCtrl'
  .otherwise
    template: JST['registrations/templates/index']
    controller: 'IndexCtrl'
]

app.factory 'registrationsFactory', ['$http', ($http) ->
  factory = {}
  factory.getRegistrations = ->
    return $http.get '/registrations.json'
  factory
]

app.controller 'InvoiceCtrl', ['$scope', '$resource', '$location', '$routeParams', '$http', ($scope, $resource, $location, $routeParams, $http) ->
  Invoice = $resource '/invoices/:id', null, {update: {method: 'PUT'}}
  $scope.invoice = Invoice.get id: $routeParams.id
  $scope.saving = false
  $scope.pay = (method, amount) ->
    $scope.invoice[method] += amount
    $scope.save()
  $scope.amount_due = () ->
    $scope.invoice.fee - $scope.amount_paid()
  $scope.amount_paid = () ->
    $scope.invoice.cash + $scope.invoice.check + $scope.invoice.points + $scope.invoice.discounts
  $scope.reset_payments = () ->
    $scope.invoice.cash = 0
    $scope.invoice.check = 0
    $scope.invoice.points = 0
    $scope.invoice.discounts = 0
    $scope.save()
  $scope.save = () ->
    $scope.saving = true
    Invoice.update {id: $scope.invoice.id}, {invoice: $scope.invoice}, ->
      $scope.saving = false
  $scope.paid = ->
    $scope.amount_due() == 0
  $scope.waiver = (registration) ->
    $http.get("/registrations/#{registration.id}/waiver").success (res) ->
      index = $scope.invoice.registrations.indexOf registration
      $scope.invoice.registrations.splice index, 1, res
]


app.controller 'IndexCtrl', ['$scope', 'registrationsFactory', ($scope, registrationsFactory) ->
  getEm = ->
    registrationsFactory.getRegistrations().success (res) ->
      $scope.squads = res

  tid = window.setInterval getEm, 5000
  getEm()

  $scope.totalShooters = ->
    total = 0
    if $scope.squads
      for squad, regs of $scope.squads
        total += regs.length
    total

  $scope.$on '$destroy', ->
    window.clearInterval tid
]

