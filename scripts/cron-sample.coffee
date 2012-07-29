cronJob = require('cron').CronJob

module.exports = (robot) ->
  send = (room, msg) ->
    response = new robot.Response(robot, {user : {id : -1, name : room}, text : "none", done : false}, [])
    response.send msg

  # *(sec) *(min) *(hour) *(day) *(month) *(week)
  new cronJob('0 40 21 * * *', () ->
    send '#your-channel-name', 'current time is 21:40. OK?'
  ).start()

