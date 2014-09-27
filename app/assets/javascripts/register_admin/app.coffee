app = angular.module 'registrations', ['ngRoute', 'ngResource']

app.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/invoice/:id',
    template: JST['register_admin/templates/show']
    controller: 'InvoiceCtrl'
  .when '/registration/:id',
    template: JST['register_admin/templates/registration']
    controller: 'RegistrationCtrl'
  .otherwise
    template: JST['register_admin/templates/index']
    controller: 'IndexCtrl'
]

app.factory 'registrationsFactory', ['$http', ($http) ->
  factory = {}
  factory.getRegistrations = ->
    return $http.get '/registrations.json'
  factory
]

app.factory 'Registration', ['$resource', ($resource) ->
  Registration = $resource '/registrations/:id.json', {id: '@id'}, {update: {method: 'PUT'}}
]

app.controller 'RegistrationCtrl', ['$scope', '$resource', '$location', '$routeParams', 'Registration', ($scope, $resource, $location, $routeParams, Registration) ->
  $scope.registration = Registration.get id: $routeParams.id
  $scope.yesno = [{value: false, text: 'No'}, {value: true, text: 'Yes'}]
  $scope.save = (registration, path = null) ->
    Registration.update {id: registration.id, registration: registration}, ->
      if path
        $location.path path
      else
        $location.path "/invoice/#{registration.invoice.id}"
]

app.controller 'InvoiceCtrl', ['$scope', '$resource', '$location', '$routeParams', '$http', 'Registration', ($scope, $resource, $location, $routeParams, $http, Registration) ->
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
      if $scope.amount_due() == 0
        $location.path '/'
  $scope.paid = (amount) ->
    $scope.amount_due() < amount
  $scope.waiver = (registration) ->
    $http.get("/registrations/#{registration.id}/waiver").success (res) ->
      index = $scope.invoice.registrations.indexOf registration
      $scope.invoice.registrations.splice index, 1, res
  $scope.edit_registration = (registration) ->
    $location.path "/registration/#{registration.id}"
  $scope.delete_registration = (registration) ->
    return true unless confirm 'Are you sure?'
    Registration.delete registration, (res) ->
      if res.registrations.length == 0 and res.fee == 0
        $location.path '/'
      else
        $scope.invoice = res
]


app.controller 'IndexCtrl', ['$scope', 'registrationsFactory', ($scope, registrationsFactory) ->
  getEm = ->
    registrationsFactory.getRegistrations().success (res) ->
      $scope.registrations = res

  tid = window.setInterval getEm, 10000
  getEm()

  $scope.totalShooters = ->
    return 0 unless $scope.registrations
    $scope.registrations.length

  $scope.squads = ->
    squads = []
    if $scope.registrations
      for reg in $scope.registrations
        if squads.indexOf(reg.squad) < 0
          squads.push reg.squad
    squads.sort()

  $scope.$on '$destroy', ->
    window.clearInterval tid
]

