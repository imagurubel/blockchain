import React, { PureComponent } from 'react';
import {
  View,
  StyleSheet
} from 'react-native';


export default function Hr(props) {
	    return <View style={ style.hr }></View>
}

const style = StyleSheet.create({
	hr: {
		borderBottomWidth: 1,
		borderColor: "rgba(0,0,0,0.1)"
	}
});