# Description
#  search twitter
#
# Dependencies:
#   "request": "2.9.203"
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Notes:
#   This script like to this:
#   https://github.com/github/hubot-scripts/blob/master/src/scripts/tweet.coffee
#   But this script can search specific locale and send a message body text
#
# Author:
#   fumiz
request = require 'request'
util    = require "util"

locale = "ja"

module.exports = (robot) ->
  robot.hear /^(@twitter) (.+)$/i, (msg) ->
    keyword = msg.match[2]
    searchTwitter keyword, (tweet) ->
      msg.send tweet

searchTwitter = (keyword, callback) ->
  options = 
    url: "http://search.twitter.com/search.json?q=#{keyword}&rpp=1&lang=#{locale}",
    encoding: 'utf8',
    timeout: 2000
    headers: {'user-agent': 'node twitter searcher'}

  request options, (error, response, text) ->
    if error? 
      console.log error
      return

    try
      json = JSON.parse(text)
      if not json.results.length > 0
        callback 'twitter->#{keyword}: no results'
        return
      tweet = json.results[0]
      tweetText = tweet.text.replace /\n/, ''
      tweetUrl  = "https://twitter.com/#{tweet.from_user}/status/#{tweet.id}"
      callback "twitter->#{keyword}: #{tweetText} - #{tweetUrl}"
    catch error
      console.log error
      return

