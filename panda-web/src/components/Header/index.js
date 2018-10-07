import React, { Component } from 'react';
import {
	View,
	Text,
	Button,
	Switch,
	StyleSheet
} from 'react-native';

const Header = ({ title }) => (
		<View style={styles.main}>
			<Text style={styles.text}>{title}</Text>
		</View>
);

export default Header;


const styles = StyleSheet.create({
	main: {
		padding: 4,
		margin: 4
	},
	text: {
		fontSize: 18,
		fontWeight: 'bold',
		textAlign: 'center'
	}
});