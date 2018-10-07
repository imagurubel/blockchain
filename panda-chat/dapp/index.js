import 'config/dclib'

import SW from 'ServiceWorker/SW'

console.groupCollapsed('⚙︎ ENV Settings')
console.table(process.env)
console.groupEnd()

document.addEventListener('DCLib::ready', e => {
  console.groupCollapsed('DCLib config')
  console.table( DCLib.config )
  console.groupEnd()
  console.log('DCLib.web3.version:', DCLib.web3.version)

  DCLib.Account.create('0xc87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3', '1234')

  window.DApp = new DCLib.DApp({
    slug : process.env.DAPP_SLUG,
    contract : require('config/dapp.contract.json'),
    rules : {
      depositX : 2
    }
  })
  //startGame();
  console.log('qweeeeeeeeeeeeeeee', window.DApp);
  document.getElementById('start').onclick = () => { startGame() }
  document.getElementById('submit').onclick = () => { submitMessage() }
})

function ascii (a) { return a.charCodeAt(0); }

function submitMessage() {
  var text = document.getElementById('textinput').value;
  var userNum = text.split('').map(ascii);
  document.getElementById('divresult').innerHTML = 'sending message "'+text+'" ...<hr>'+document.getElementById('divresult').innerHTML;


  window.DApp.Game(1, userNum, DCLib.randomHash({bet:1, gamedata:userNum})).then(function(res) {
    console.log('callback')
	console.log(res)
	var hashCheck = (res.bankroller.result.random_hash === res.local.result.random_hash) ? 'OK' : 'ERROR';
	console.log(hashCheck)
	var append = 'sent message: "' + res.bankroller.result.result_word + '". Message hash checked: ' + hashCheck + '<hr>';
	document.getElementById('divresult').innerHTML = append + document.getElementById('divresult').innerHTML;
  })

}

function startGame() {
    window.DApp.connect(
      {
        bankroller: 'auto',
        paychannel: { deposit: 100 },
        gamedata: { type: 'uint', value: [1, 2, 3] }
      },
      function(connected, info) {
        console.log('connect result:', connected);
        console.log('connect info:', info);
        if (!connected) return;
      }
    );
}



// Register Service Worker
if (process.env.DAPP_SW_ACTIVE) SW.register()
