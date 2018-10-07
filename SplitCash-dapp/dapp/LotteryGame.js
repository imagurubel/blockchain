import React, { Component } from 'react'
import './lottery-game.css';
export default class LotteryGame extends Component {

	handleClick(e) {
		const userChoice = parseInt(e.target.id.substr(-1));
		document.querySelector('.choice-row .active') ? document.querySelector('.choice-row .active').classList.remove('active') : console.log('#user choice',userChoice);
		document.querySelector(`#choice_${userChoice}`).classList.toggle('active');
	}

	render() {
		return (
			<React.Fragment>
			<div className="lottery-game-container">
				<h3>Lottery</h3>
				<div className="ticket">
					<h5>The Ticket</h5>
					<div className="choice-row">
						<span id="choice_1" onClick={e => this.handleClick(e)}>⬤</span>
						<span id="choice_2" onClick={e => this.handleClick(e)}>⬤</span>
						<span id="choice_3" onClick={e => this.handleClick(e)}>⬤</span>
					</div>
					<div className="choice-row">
						<span id="choice_4" onClick={e => this.handleClick(e)}>⬤</span>
						<span id="choice_5" onClick={e => this.handleClick(e)}>⬤</span>
						<span id="choice_6" onClick={e => this.handleClick(e)}>⬤</span>
					</div>
				</div>
			</div>
			<div className="user-bet-container">
				<input type="range" />
			</div>
			</React.Fragment>
		)
	}
}
