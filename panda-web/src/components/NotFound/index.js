import React, { Component } from 'react';
import {
	Text
} from 'react-native';

import Status from '../Status';

export default class Element extends Component {
	render(){
		return <Status code={404}>
			<Text>404</Text>
		</Status>
	}

}
