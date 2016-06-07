# Description
#   Hubot talks to Zenoss
#
# Configuration:
#   ZENOSS_SERVER_URL
#   ZENOSS_USERNAME
#   ZENOSS_PASSWORD
#
# Commands:
#   hubot zen status <server> - Displays status for server.
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Luke D'Alfonso <pokemonmegaman@yahoo.com>

#Base64 encode user:pass.
btoa = require "btoa"
#TODO: don't use my own!
auth = "Basic " + btoa(process.env.ZENOSS_USERNAME + ':' + process.env.ZENOSS_PASSWORD)
module.exports = (robot) ->
  robot.respond /zen status (.+)/, (res) ->
    # Lookup the device in Zenoss to get the UID
    deviceName = res.match[0]
    data = JSON.stringify({
      action: 'DeviceRouter',
      method: 'getDevices',
      data: [ { params: { name: deviceName }, limit: 1 } ],
      tid: 1 })
    robot.http(process.env.ZENOSS_SERVER_URL + "/zport/dmd/device_router")
      .header('Content-Type', 'application/json')
      .header('Authoriztion', auth)
      .post(err, response, body) ->
        result = JSON.parse(body).result
        if (result.totalCount)
          res.reply "Unable to find " + deviceName + "."
        else
          data = JSON.stringify({
            action: 'DeviceRouter',
            method: 'getInfo',
            #UID retrieved from initial request.
            data: [ { uid: result.devices[0].uid} ],
            tid: 1 })
          robot.http(process.env.ZENOSS_SERVER_URL + "/zport/dmd/device_router")
          .header('Content-Type', 'application/json')
          .header('Authoriztion', auth)
          .post(err, response, body) ->
            # Message format:
            # name (IP) is (UP/DOWN) - n events (n error, n critical, n warning)
            result = JSON.parse(body).result
            status = "DOWN"
            # Below is true if machine is up
            if (result.data.status)
              status = "UP"
            eventTotal = result.events.info.count + result.events.clear.count + result.events.warning.count + result.events.critical.count + result.events.error.count + result.events.debug.count
            # eventAck = result.events.info.acknowledged_count + result.events.clear.acknowledged_count + result.events.warning.acknowledged_count + result.events.critical.acknowledged_count + result.events.error.acknowledged_count + result.events.debug.acknowledged_count
            res.reply (result.data.name + "(" + result.data.ipAddressString + ") is " + status + " - " + eventTotal + " events (" + result.events.error.count + "error, " + result.events.critical.count + " critical, " +  result.events.warning.count " warn)")
  robot.hear /orly/, (res) ->
    res.send "yarly"
