# hubot-zenoss

Hubot talks to Zenoss

See [`src/zenoss.coffee`](src/zenoss.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-zenoss --save`

Then add **hubot-zenoss** to your `external-scripts.json`:

```json
[
  "hubot-zenoss"
]
```

## Sample Interaction

```
user1>> hubot zen status prodsrv01
hubot>> user1: prodsrv01(192.168.0.8) is UP - 3 events (2 error, 0 critical, 1 warn)
```

## NPM Module

https://www.npmjs.com/package/hubot-zenoss
