import React, { Component } from 'react';
import {
  StyleSheet,
  Text,
  View,
  Button,
  Picker,
  Modal,
  TouchableWithoutFeedback
} from 'react-native';

import Row from '../Row';

export default class CapPicker extends Component {
	constructor(props){
		super(props);

		this.state = {};

		if ('selectedIndex' in props){

			this.state.selectedIndex = props.selectedIndex;

		} else {

			this.state.selectedIndex = 0
		}


	}


	render(){
		var { data, onDone, onCancel, onLabel } = this.props;
		const { selectedIndex } = this.state;
		console.log(selectedIndex);
		return <Modal transparent={true} animationType={'fade'}>
					<TouchableWithoutFeedback style={styles.flex} onPress={onCancel}>
						<View style={styles.view} />
					</TouchableWithoutFeedback>

					<View style={styles.panel}>
						<Picker
							selectedValue={selectedIndex}
							onValueChange={(value)=>{
								this.setState({
									selectedIndex: value
								});
							}}>

							{data.map((capItem, capIndex)=><Picker.Item key={capIndex} label={onLabel instanceof Function && onLabel(capItem, capIndex) || capItem} value={capIndex} />)}
						</Picker>
						
					</View>

					<Row style={styles.panel}>
						<Button title={'CANCEL'} onPress={onCancel}/>
						<Button disabled={selectedIndex === 'none'} title={'DONE'} onPress={()=>onDone(selectedIndex)}/>
					</Row>
			</Modal>
	}
}


const styles = StyleSheet.create({
	flex: {
		flex: 1,
	},
	view: {
		flex: 1,
		backgroundColor: 'rgba(0,0,0,0.5)'
	},
	picker: {
		paddingLeft: 4,
		paddingRight: 4
	},
	panel: {
		backgroundColor: 'white'
	}
});




