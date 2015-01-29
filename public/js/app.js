var app = angular.module('association', [])

app.controller('statusController', function($scope) {
<<<<<<< HEAD
  $scope.status = { authorized: true,
                    type: 'declared',
                    mean_publication: true,
                    mean_event: true,
                    mean_manifestation: true,
                    mean_others: true }
=======
  $scope.status = {}
>>>>>>> 5d7b4b9... Simplify the app.js file for now

  // isValid - true/false meaning the form is valid or not
  $scope.submit = function(isValid, $event) {
    $event.target.submit()
  }
});
