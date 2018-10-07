import React from 'react';
import {
  View,
  Text,
  ActivityIndicator,
  StyleSheet
} from 'react-native';

import Row from '../Row';

export default function Indicator({title}){
	   return <Row style={styles.main}><Text style={styles.text}>{title}</Text><ActivityIndicator /></Row>
}

var styles = StyleSheet.create({
	text: {
		paddingRight: 4,
		marginRight: 4
	},
    main: {
        margin: 4,
        padding: 4
    }
});