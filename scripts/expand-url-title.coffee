# Description
#  expands url to title
#
# Dependencies:
#   "iconv": "1.2.3",
#   "node-icu-charset-detector": "0.0.3",
#   "cheerio": "0.9.0"
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
#   https://github.com/github/hubot-scripts/blob/master/src/scripts/web.coffee
#   But this script can parse multibyte characters.
#
#   This script require installed "ICU" and "iconv" in your system.
#   ICU: http://site.icu-project.org/
#
# Author:
#   fumiz
request = require 'request'
charsetDetector = require "node-icu-charset-detector"
CharsetMatch    = charsetDetector.CharsetMatch
Iconv   = require("iconv").Iconv;
cheerio = require 'cheerio'

module.exports = (robot) ->
  robot.hear /((https?|ftp)(:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+))/i, (msg) ->
    url = msg.match[0]
    getWebPageTitle url, (title) ->
      msg.send title

getWebPageTitle = (url, callback) ->
  options = 
    url: url,
    encoding: null,
    timeout: 2000
    headers: {'user-agent': 'node title fetcher'}

  request options, (error, response, bodyTextBuffer) ->
      if error? 
        callback "couldn't fetch a web page from #{url}"
        return

      charsetMatch = new CharsetMatch(bodyTextBuffer);
      text = bufferToString(bodyTextBuffer, charsetMatch.getName());

      $ = cheerio.load text
      title = $('title').text().replace /\n/g, ''

      if title is ''
        callback "couldn't find a title from #{url}"
        return

      callback title

bufferToString = (buffer, charset) ->
  try
    buffer.toString charset
  catch error
    charsetConverter = new Iconv(charset, "utf8");
    charsetConverter.convert(buffer).toString();

