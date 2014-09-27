app = angular.module 'registrations', ['ngResource']

app.factory 'registrationsFactory', ['$http', ($http) ->
  factory = {}
  factory.getRegistrations = ->
    return $http.get '/registrations.json'
  factory
]


app.controller 'IndexCtrl', ['$scope', 'registrationsFactory', ($scope, registrationsFactory) ->
  self = this
  getEm = ->
    registrationsFactory.getRegistrations().success (res) ->
      self.registrations = res

  tid = window.setInterval getEm, 10000
  getEm()

  $scope.$on '$destroy', ->
    window.clearInterval tid

  self
]
