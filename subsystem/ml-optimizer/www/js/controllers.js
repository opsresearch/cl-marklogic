angular.module('starter.controllers', [])

.controller('AppCtrl', function($scope, $ionicModal, $timeout) {

  // With the new view caching in Ionic, Controllers are only called
  // when they are recreated or on app start, instead of every page change.
  // To listen for when this page is active (for example, to refresh data),
  // listen for the $ionicView.enter event:
  //$scope.$on('$ionicView.enter', function(e) {
  //});

  // Form data for the login modal
  $scope.loginData = {};

  // Create the login modal that we will use later
  $ionicModal.fromTemplateUrl('templates/login.html', {
    scope: $scope
  }).then(function(modal) {
    $scope.modal = modal;
  });

  // Triggered in the login modal to close it
  $scope.closeLogin = function() {
    $scope.modal.hide();
  };

  // Open the login modal
  $scope.login = function() {
    $scope.modal.show();
  };

  // Perform the login action when the user submits the login form
  $scope.doLogin = function() {
    console.log('Doing login', $scope.loginData);

    // Simulate a login delay. Remove this and replace with your login
    // code if using a login system
    $timeout(function() {
      $scope.closeLogin();
    }, 1000);
  };
})


.controller('ClustersCtrl', function($scope, $http) {
    $http.get('/cluster').then(function successCallback(response) {
        $scope.clusters = response.data;
      },
      function errorCallback(response) {
        $scope.clusters = [];
      });
})

.controller('ClusterCtrl', function($scope, $stateParams, $http) {
  $http({
    method: 'GET',
    url: '/cluster',
    params: {id: $stateParams.clusterId}
    }).then(function successCallback(response) {
        $scope.cluster = response.data;
      },
      function errorCallback(response) {
        $scope.cluster = {};
      });
  })

.controller('GroupsCtrl', function($scope, $http) {
    $http.get('/group').then(function successCallback(response) {
        $scope.groups = response.data;
      },
      function errorCallback(response) {
        $scope.groups = [];
      });
})

.controller('GroupCtrl', function($scope, $stateParams, $http) {
  $http({
    method: 'GET',
    url: '/group',
    params: {id: $stateParams.groupId}
    }).then(function successCallback(response) {
        $scope.group = response.data;
      },
      function errorCallback(response) {
        $scope.group = {};
      });
  })

.controller('HostsCtrl', function($scope, $http) {
    $http.get('/host').then(function successCallback(response) {
        $scope.hosts = response.data;
      },
      function errorCallback(response) {
        $scope.hosts = [];
      });
})

.controller('HostCtrl', function($scope, $stateParams, $http) {
  $http({
    method: 'GET',
    url: '/host',
    params: {id: $stateParams.hostId}
    }).then(function successCallback(response) {
        $scope.host = response.data;
      },
      function errorCallback(response) {
        $scope.host = {};
      });
  })

.controller('DatabasesCtrl', function($scope, $http) {
    $http.get('/database').then(function successCallback(response) {
        $scope.databases = response.data;
      },
      function errorCallback(response) {
        $scope.databases = [];
      });
})

.controller('DatabaseCtrl', function($scope, $stateParams, $http) {
  $http({
    method: 'GET',
    url: '/database',
    params: {id: $stateParams.databaseId}
    }).then(function successCallback(response) {
        $scope.database = response.data;
      },
      function errorCallback(response) {
        $scope.database = {};
      });
  })

.controller('ForestsCtrl', function($scope, $http) {
    $http.get('/forest').then(function successCallback(response) {
        $scope.forests = response.data;
      },
      function errorCallback(response) {
        $scope.forests = [];
      });
})

.controller('ForestCtrl', function($scope, $stateParams, $http) {
  $http({
    method: 'GET',
    url: '/forest',
    params: {id: $stateParams.forestId}
    }).then(function successCallback(response) {
        $scope.forest = response.data;
      },
      function errorCallback(response) {
        $scope.forest = {};
      });
  })

.controller('OptForestsCtrl', function($scope, $http) {
});

