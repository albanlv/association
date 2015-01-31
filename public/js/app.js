var app = angular.module('association', [])

app.controller('statusController', function($scope) {
  $scope.status = { authorized: true,
                    type: 'declared',
                    mean_publication: true,
                    mean_event: true,
                    mean_manifestation: true,
                    mean_others: true }

  // isValid - true/false meaning the form is valid or not
  $scope.submit = function(isValid, $event) {
    $event.target.submit()
  }
});
