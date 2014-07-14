# GitHub Repo Aggregator

A small tool to download and zip all the repos belong to a user's organizations from GitHub.

## Usage

Clone this repo and add a new file called keys.js, with the following content:

```js
module.exports = {
  username: <replace with your username>,
  password: <replace with your password>
}
```

Then run index.js.