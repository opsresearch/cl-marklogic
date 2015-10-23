// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
// 'starter.controllers' is found in controllers.js
angular.module('starter', ['ionic', 'starter.controllers'])

.run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      cordova.plugins.Keyboard.disableScroll(true);

    }
    if (window.StatusBar) {
      // org.apache.cordova.statusbar required
      StatusBar.styleDefault();
    }
  });
  })

.config(function($stateProvider, $urlRouterProvider) {
  $stateProvider

  .state('app', {
    url: '/app',
    abstract: true,
    templateUrl: 'templates/menu.html',
    controller: 'AppCtrl'
  })

  .state('app.clusters', {
    url: "/clusters",
    views: {
        'menuContent': {
            templateUrl: "templates/clusters.html",
            controller: 'ClustersCtrl'
        }
    }
  })

  .state('app.cluster', {
    url: "/clusters/:clusterId",
    views: {
        'menuContent': {
          templateUrl: "templates/cluster.html",
          controller: 'ClusterCtrl'
      }
    }
  })

  .state('app.groups', {
    url: "/groups",
    views: {
        'menuContent': {
            templateUrl: "templates/groups.html",
            controller: 'GroupsCtrl'
        }
    }
  })

  .state('app.group', {
    url: "/groups/:groupId",
    views: {
        'menuContent': {
          templateUrl: "templates/group.html",
          controller: 'GroupCtrl'
      }
    }
  })

   .state('app.hosts', {
    url: "/hosts",
    views: {
        'menuContent': {
            templateUrl: "templates/hosts.html",
            controller: 'HostsCtrl'
        }
    }
  })

  .state('app.host', {
    url: "/hosts/:hostId",
    views: {
        'menuContent': {
          templateUrl: "templates/host.html",
          controller: 'HostCtrl'
      }
    }
  })

  .state('app.databases', {
    url: "/databases",
    views: {
        'menuContent': {
            templateUrl: "templates/databases.html",
            controller: 'DatabasesCtrl'
        }
    }
  })

  .state('app.database', {
    url: "/databases/:databaseId",
    views: {
        'menuContent': {
          templateUrl: "templates/database.html",
          controller: 'DatabaseCtrl'
      }
    }
  })

  .state('app.forests', {
    url: "/forests",
    views: {
        'menuContent': {
            templateUrl: "templates/forests.html",
            controller: 'ForestsCtrl'
        }
    }
  })

  .state('app.forest', {
    url: "/forests/:forestId",
    views: {
        'menuContent': {
          templateUrl: "templates/forest.html",
          controller: 'ForestCtrl'
      }
    }
  });

  // if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise('/app/databases');
});
