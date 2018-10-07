/* global alert */

import './tutorial.less'
import template from './tutorial.tpl.js'

import App from 'app'

const DEMO_privkey = '0xc87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3'

export default new class View {
  // constructor () {

  // }

  init () {
    document.getElementById('tutorial_mount_point').innerHTML = template
    this.root = document.getElementById('tutorial_app')
    this.setEvents()
  }

  setEvents () {
    this.root.querySelector('.step-0 button').onclick = () => { this.showStep1() }
  }

  showStep (num) {
    this.root.className = 'show-step-' + num
  }

  showStep1 () {
    this.showStep(1)
    const privkey_input = this.root.querySelector('.step-1 input[name="privkey"]')

    if (window.localStorage.last_privkey) {
      privkey_input.value = window.localStorage.last_privkey
    } else {
      setTimeout(() => { if (!privkey_input.value) privkey_input.value = DEMO_privkey }, 7777)
    }

    const btn = this.root.querySelector('.step-1 button')
    btn.onclick = () => {
      btn.disabled = true
      this.root.querySelector('.step-1 .init').style.display = 'none'

      setTimeout(async () => {
        try {
          DCLib.Account.create(privkey_input.value, '1234')
          window.localStorage.last_privkey = privkey_input.value
        } catch (e) {
          btn.disabled = false
          this.root.querySelector('.step-1 .init').style.display = 'block'
          alert('invalid key')
          return
        }

        const acc_info = await DCLib.Account.info()
        document.getElementById('acc_info').innerHTML = JSON.stringify(acc_info)
        this.root.querySelector('.step-1').classList.add('initied')
        setTimeout(() => {
          this.showStep2()
        }, 3333)
      }, 33)
    }
  }

  showStep2 () {
    this.showStep(2)

    const btn = this.root.querySelector('.step-2 button')
    btn.onclick = async () => {
      btn.disabled = true
      window.MyApp = await App.init({
        slug : process.env.DAPP_SLUG,
        contract : require('config/dapp.contract.json'),
        rules : {
          depositX : 2
        }
      })

      const log = document.getElementById('log')
      window.MyApp.Status.on('error', data => {
        log.style.display = 'block'
        log.innerHTML += `<p><b>ERROR</b>: ${JSON.stringify(data)}</p>`
      }).on('connect::info', data => {
        log.style.display = 'block'
        log.innerHTML += `<p><b>INFO</b>: ${JSON.stringify(data)}</p>`
      }).on('connect::error', data => {
        log.style.display = 'block'
        log.innerHTML += `<p><b>ERROR</b>: ${JSON.stringify(data)}</p>`
      })

      this.showStep3()
    }
  }

  showStep3 () {
    this.showStep(3)

    const btn = this.root.querySelector('.step-3 button')
    btn.onclick = async () => {
      btn.disabled = true
      const deposit = this.root.querySelector('.step-3 input[name="deposit"]').value

      const connection = await App.startGame(deposit)

      if (!connection.connected) {
        btn.disabled = false
        console.warn('Cant connect, please repeat...')
        return
      }

      console.info('Connect result', connection)
      this.showStep4(connection)
    }
  }

  showStep4 (connection) {
    this.showStep(4)

    const table = document.querySelector('.step-4 table.play-log tbody')
    let playCnt = 0


    const endBtn = this.root.querySelector('.step-4 button.next')
    endBtn.disabled = true
    endBtn.onclick = () => {
      this.showStep5()
      this.disconnect()
    }

    const btn = this.root.querySelector('.step-4 button.play')
    btn.onclick = async () => {
      btn.disabled = true
      btn.innerHTML = 'wait...'

      const bet    = +document.querySelector('.step-4 input[name="bet"]').value
      const choice = +document.querySelector('.step-4 input[name="choice"]:checked').value

      const play = await App.play(bet, choice)
      console.info('Play result:')
      console.table(play.bankroller.result)

      const r = play.bankroller.result
      table.insertAdjacentHTML('beforeend', `
        <tr>
          <td>${r.user_bet}</td>
          <td>${r.user_num}</td>
          <td><div class="t" title="${r.random_hash}">${r.random_hash}</div></td>
          <td>${r.random_num}</td>
          <td>${Math.ceil(r.profit * 0.000000000000000001)}</td>
          <td>${r.balance}</td>
        </tr>
      `)


      endBtn.disabled = false
      if ((playCnt++) > 3) {
        setTimeout(() => { this.showStep5() }, 3333)
        return
      }
      btn.disabled = false
      btn.innerHTML = 'Play'
    }

  }

  showStep5 () {
    this.showStep(5)
    this.root.querySelector('.step-5 button').onclick = this.disconnect
  }

  async disconnect () {
    const btn = document.querySelector('.step-5 button')
    btn.disabled = true
    this.root.querySelector('.step-5 .close-block').style.display = 'none'

    const disconnect = await App.endGame()
    console.info('Disconnect result:', disconnect)
    this.root.querySelector('.step-5 #close_result').innerHTML = JSON.stringify(disconnect)

    this.root.querySelector('.step-5 .outro-block').style.display = 'block'
  }

}()
