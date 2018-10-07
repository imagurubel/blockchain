import React, { PureComponent } from 'react';
import {
	View,
	Text,
	FlatList,
	StyleSheet
} from 'react-native';
import Hr from '../Hr';
import Header from '../Header';
import { connect } from 'react-redux';

class MyOrders extends PureComponent {

	render(){
		return <View>
			<Header title={'My placed orders'} />
        </View>
	}
	
}


const mapStateToProps = ({data})=>{

	return {

	}
}

const styles = StyleSheet.create({
	text: {
		padding: 4,
		margin: 4
	}
})

export default connect(mapStateToProps)(MyOrders);