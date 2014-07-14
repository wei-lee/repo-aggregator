var request = require('request');
var GithubApi = require('github');
var async = require('async');
var _ = require('lodash');

var path = require('path');
var fs = require('fs');

var exec = require('child_process').exec;

var github = new GithubApi({
  version: '3.0.0'
});

var auth = require('./keys');
var DIR_NAME = './archives';
if(!fs.existsSync(DIR_NAME)){
  fs.mkdirSync(DIR_NAME);
}

var getOAuthToken = function(cb){
  var userInfo = auth;
  userInfo.type = 'basic';
  github.authenticate(userInfo);
  github.authorization.getAll({}, function(err, authorizations){
    if(err){
      return cb(err);
    }
    var token = _.filter(authorizations, {'note':'read repo info'});
    var oauthToken = null;
    if(token && token.length === 1){
      oauthToken = token[0].token;
      github.authenticate({
        type:'oauth',
        token:oauthToken
      });
      return cb(null, oauthToken);
    } else {
      github.authorization.create({
        scopes:["repo"],
        note:'read repo info'
      }, function(err, res){
        if(err){
          return cb(err);
        }
        if(res.token){
          oauthToken = res.token;
          github.authenticate({
            type:'oauth',
            token:oauthToken
          });
          return cb(null, oauthToken);
        }
      });
    }
  });
}

var getOrgs = function(cb){
  getOAuthToken(function(err, token){
    if(err){
      return cb(err);
    }
    github.user.getOrgs({}, function(err, res){
      if(err){
        return cb(err);
      }
      var allorgs = _.pluck(res, 'login');
      return cb(null, allorgs);
    });
  });
}

var getReposForOrg = function(org, cb){
  github.repos.getFromOrg({
    org:org
  }, function(err, res){
    if(err){
      return cb(err);
    }
    var repos = _.pluck(res, 'name');
    return cb(null, repos);
  });
}

var dowloadRepoForOrg = function(org, cb){
  getReposForOrg(org, function(err, repos){
    if(err){
      return cb(err);
    }
    async.eachSeries(repos, function(repoName, callback){
      github.repos.getArchiveLink({
        user: org,
        repo: repoName,
        archive_format:'tarball',
        ref:'heads/master'
      }, function(err, res){
        if(err){
          return cb(err);
        }
        console.log('Downloading archive for repo : ' + org + '/' + repoName + ' from ' + res.meta.location);
        var filename = [org, repoName].join('_') + '.tar.gz';
        var file = path.join(DIR_NAME, filename);
        var fileStream = fs.createWriteStream(file);
        fileStream.on('finish', function(){
          console.log("Finished writing to file " + file);
          callback();
        });
        fileStream.on('error', function(){
          console.error("Error when writing to file " + file);
          callback();
        })
        request(res.meta.location).pipe(fileStream);
      });
    }, function(err){
      if(err){
        return cb(err);
      }
      return cb();
    });
  });
}


var getRepos = function(){
  getOrgs(function(err, orgs){
    if(err){
      console.error(err);
    } else {
      console.log("got orgs", orgs);
      async.each(orgs, function(orgName, cb){
        dowloadRepoForOrg(orgName, cb);
      }, function(err){
        if(err){
          console.error(err);
          process.exit(1);
        } else {
          console.log("All repos downloaded, creating archive...");
          zipAll();
        }
      });
    }
  });
}

var zipAll = function(){
  exec('tar -cvzf master.tar.gz ' + DIR_NAME, {cwd: __dirname}, function(error, stdout, stderr){
    console.log(stdout);
    console.error(stderr);
    process.exit(0);
  });
}

getRepos();


