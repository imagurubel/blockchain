import React, { Component } from 'react';
import {
	View,
	Text,
	StyleSheet,
	Image,
	Button,

} from 'react-native';

const Home = ({ dispatch, todos }) => (
		<View style={styles.main}>


		</View>
);

export default Home;


const styles = StyleSheet.create({
	main: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center'
	},
	text: {
		padding: 4,
		margin: 4,
		backgroundColor: '#2196F3',
		color: 'white',
		fontWeight: 'bold',
		fontSize: 24
	}
});