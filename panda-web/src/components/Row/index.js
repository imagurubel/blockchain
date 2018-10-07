import React from 'react';
import {
  View,
  StyleSheet
} from 'react-native';

export default function Row({children, style}){
	   return <View style={[styles.View, style]}>{children}</View>
}

var styles = StyleSheet.create({
    View: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between'
    }
});