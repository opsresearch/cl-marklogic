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

.controller('SettingsCtrl', function($scope, $http) {
    $http.get('api/setting').then(function successCallback(response) {
        $scope.settings = response.data;
      },
      function errorCallback(response) {
        $scope.settings = [];
      });
})

.controller('SettingCtrl', function($scope, $stateParams, $http) {
  $http({
    method: 'GET',
    url: 'api/setting',
    params: {id: $stateParams.settingId}
    }).then(function successCallback(response) {
        $scope.setting = response.data;
      },
      function errorCallback(response) {
        $scope.setting = {};
      });
    $http.get('api/id-names').then(function successCallback(response) {
        $scope.idNames = response.data;
      },
      function errorCallback(response) {
        $scope.idNames = [];
      });
  })

.controller('ClustersCtrl', function($scope, $http) {
    $http.get('api/cluster').then(function successCallback(response) {
        $scope.clusters = response.data;
      },
      function errorCallback(response) {
        $scope.clusters = [];
      });
})

.controller('ClusterCtrl', function($scope, $stateParams, $http) {
  $http({
    method: 'GET',
    url: 'api/cluster',
    params: {id: $stateParams.clusterId}
    }).then(function successCallback(response) {
        $scope.cluster = response.data;
      },
      function errorCallback(response) {
        $scope.cluster = {};
      });
    $http.get('api/id-names').then(function successCallback(response) {
        $scope.idNames = response.data;
      },
      function errorCallback(response) {
        $scope.idNames = [];
      });
  })

.controller('GroupsCtrl', function($scope, $http) {
    $http.get('api/group').then(function successCallback(response) {
        $scope.groups = response.data;
      },
      function errorCallback(response) {
        $scope.groups = [];
      });
})

.controller('GroupCtrl', function($scope, $stateParams, $http) {
  $http({
    method: 'GET',
    url: 'api/group',
    params: {id: $stateParams.groupId}
    }).then(function successCallback(response) {
        $scope.group = response.data;
      },
      function errorCallback(response) {
        $scope.group = {};
      });
     $http.get('api/id-names').then(function successCallback(response) {
        $scope.idNames = response.data;
      },
      function errorCallback(response) {
        $scope.idNames = [];
      });
 })

.controller('HostsCtrl', function($scope, $http) {
    $http.get('api/host').then(function successCallback(response) {
        $scope.hosts = response.data;
      },
      function errorCallback(response) {
        $scope.hosts = [];
      });
})

.controller('HostCtrl', function($scope, $stateParams, $http) {
  $http({
    method: 'GET',
    url: 'api/host',
    params: {id: $stateParams.hostId}
    }).then(function successCallback(response) {
        $scope.host = response.data;
      },
      function errorCallback(response) {
        $scope.host = {};
      });
    $http.get('api/id-names').then(function successCallback(response) {
        $scope.idNames = response.data;
      },
      function errorCallback(response) {
        $scope.idNames = [];
      });
  })

.controller('DatabasesCtrl', function($scope, $http) {
    $http.get('api/database').then(function successCallback(response) {
        $scope.databases = response.data;
      },
      function errorCallback(response) {
        $scope.databases = [];
      });
})

.controller('DatabaseCtrl', function($scope, $stateParams, $http) {
  $http({
    method: 'GET',
    url: 'api/database',
    params: {id: $stateParams.databaseId}
    }).then(function successCallback(response) {
        $scope.database = response.data;
      },
      function errorCallback(response) {
        $scope.database = {};
      });
    $http.get('api/id-names').then(function successCallback(response) {
        $scope.idNames = response.data;
      },
      function errorCallback(response) {
        $scope.idNames = [];
      });
  })

.controller('ForestsCtrl', function($scope, $http) {
    $http.get('api/forest').then(function successCallback(response) {
        $scope.forests = response.data;
      },
      function errorCallback(response) {
        $scope.forests = [];
      });
})

.controller('ForestCtrl', function($scope, $stateParams, $http) {
  $http({
    method: 'GET',
    url: 'api/forest',
    params: {id: $stateParams.forestId}
    }).then(function successCallback(response) {
        $scope.forest = response.data;
      },
      function errorCallback(response) {
        $scope.forest = {};
      });
     $http.get('api/id-names').then(function successCallback(response) {
        $scope.idNames = response.data;
      },
      function errorCallback(response) {
        $scope.idNames = [];
     });
  });


