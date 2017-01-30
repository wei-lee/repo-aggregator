# GitHub Repo Aggregator

A small tool to download and zip all the repos belong to a user's organizations from GitHub.

## Usage

1. create a personal access token first on Github. Make sure it will have the permission to read the user's organizations, and repos.

2. Clone this repo and add a new file called keys.js, with the following content:

```js
module.exports = {
  token: <replace with your personal access token>
}
```

Then run index.js.