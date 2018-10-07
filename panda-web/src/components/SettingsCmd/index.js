import React, { Component } from 'react';
import {
	Button,
	TouchableOpacity,
	StyleSheet,
	Text
} from 'react-native';
import Row from '../Row';

import { connect } from 'react-redux';

export const SettingsCmd = ({account, onPress})=>{
	return <Button title={account && account.address || 'SETTINGS'} onPress={onPress}/>
}

function mapStateToProps({data, dispatch}) {
	return {
        account: data.account
	}
}

export default connect(mapStateToProps)(SettingsCmd);