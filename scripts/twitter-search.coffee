# Description
#  search twitter by given keyword and say a tweet from top of results
#
# Dependencies:
#   "request": "2.9.203"
#
# Configuration:
#   None
#
# Commands:
#   @twitter <keyword>
#
# Notes:
#   "lang" option requires ISO 639-1 code
#   see also -> https://dev.twitter.com/docs/api/1/get/search
#
# Author:
#   fumiz
request = require 'request'

lang = 'ja'

module.exports = (robot) ->
  robot.hear /^(@twitter) (.+)$/i, (msg) ->
    keyword = msg.match[2]
    searchTwitter keyword, (tweet) ->
      msg.send tweet

searchTwitter = (keyword, callback) ->
  encodedKeyword = encodeURIComponent keyword
  options = 
    url: "http://search.twitter.com/search.json?q=#{encodedKeyword}&rpp=1&lang=#{lang}",
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
      tweetUrl  = "https://twitter.com/#{tweet.from_user}/status/#{tweet.id_str}"
      callback "twitter->#{keyword}: (@#{tweet.from_user}) #{tweetText} - #{tweetUrl}"
    catch error
      console.log error
      callback 'twitter->an unexpected error occurred'
      return

