/* global DCLib */

DCLib.defineDAppLogic(process.env.DAPP_SLUG, function (payChannel) {

  let gameTypes = [
    [{dataSize:2, rate:6, min:1, max: 6, exists:true}],
    [{dataSize:2, rate:15, min:1, max: 15, exists:true}],
    [{dataSize:4, rate:5, min:1, max: 15, exists:true}],
    [{dataSize:6, rate:3, min:1, max: 15, exists:true}],
  ]


  let history = []

  var Roll = function (userBet, gameData, random_hash) {
    let _game = _gameData[0];

    if (gameData.length != gameTypes[_game][0].dataSize) {
      console.warn('Invalid dataSize')
      return
    }


    // convert 1BET to 100000000
    userBet = DCLib.Utils.bet2dec(userBet)
    // generate random number
    console.log(random_hash, userBet, MAX_RAND_NUM)
    const randomNum = DCLib.numFromHash(random_hash, gameTypes[_game][0].min, gameTypes[_game][0].max)

    let profit = -userBet

    for (let i = 2; i <= gameTypes[_game][0].dataSize; i++) {
      if (_gameData[i] == _rndNumber) {
        profit = userBet * gameTypes[_game][0].rate - userBet
      }
    }

    // if (userNum * 1 === randomNum * 1) {
    //   profit = userBet * 2 - userBet
    // }

    // add result to paychannel
    payChannel.addTX(profit)

    // console log current paychannel state
    payChannel.printLog()

    // push all data to our log
    // just FOR DEBUG
    const rollItem = {
      // !IMPORTANT Time can be different on client and bankroller sides
      // not use time in your primary game logic
      timestamp   : new Date().getTime(),

      user_bet    : userBet,
      profit      : profit,
      game_id     : _game,
      balance     : payChannel.getBalance(),
      random_hash : random_hash,
      random_num  : randomNum
    }
    history.push(rollItem)

    return rollItem
  }

  return {
    Game: Roll,
    history: history
  }
})
