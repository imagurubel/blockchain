import React, { Component } from 'react';
import {
	View,
	Text,
	Button,
	FlatList,
	StyleSheet
} from 'react-native';
import Hr from '../Hr';
import Header from '../Header';

export default class OrderConfirmation extends Component {
	state = {
		data: []
	}

	renderItem({item, index}){
		return <View>
			<Text>{String(index)}</Text>
		</View>
	}
	render(){
		const { data } = this.state;

		return <View>
			<Header title={'Order confirmation'} />
			<FlatList
                renderItem={this.renderItem.bind(this)}
                data={data}
                keyboardDismissMode={ 'on-drag'}
                keyboardShouldPersistTaps = {"always" }
                ItemSeparatorComponent={<Hr/>}
                keyExtractor={(item, index)=>String(index)}
            />
        </View>
	}
	
}


