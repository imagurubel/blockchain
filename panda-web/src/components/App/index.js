import React, { Component, PureComponent } from 'react';
import {
	View,
	Text,
	StyleSheet,
	Image,
	Button
} from 'react-native';
import { Switch, Route, Link } from 'react-router-native';
import Home from '../Home';
import NotFound from '../NotFound';
import Row from '../Row';
import PlaceOrder from '../PlaceOrder';

import OrderConfirmation from '../OrderConfirmation';
import MyOrders from '../MyOrders';
import Settings from '../Settings';
import SettingsCmd from '../SettingsCmd';
import { connect } from 'react-redux';
import img from '../../../public/images/assets/image.jpg';
function Go({to, title}){
	return <Link to={to}><Text style={styles.link}>{title || to}</Text></Link>
}

export default class Body extends Component {
	state = {
		showMenu: false
	}
	render(){
		const { showMenu } = this.state;
		const { account } = this.props;

		return <View style={styles.flex}>
					{showMenu && <View style={styles.menu}>
						<Settings />
					</View>}
					<Row style={styles.header}>
						<Row style={[styles.flex, styles.login]}>
							<SettingsCmd onPress={()=>this.setState({
									showMenu: !showMenu
							})}/>
						</Row>
						<Row style={styles.links}>

							<Go title={'Home'} to='/' />
							<Go title={'My Orders'} to='/MyOrders' />
							<Go title={'Place Order'} to='/PlaceOrder' />
							<Go title={'Order Confirmation'} to='/OrderConfirmation' />

						</Row>
						<Text numberOfLines={1} style={styles.headerText}>
							<Text style={{color: 'red'}}>PANDA <Text style={{color: '#2196F3'}}>TRANSLEREUM</Text></Text>
						</Text>
					</Row>
					<Image accessibilityLabel='alt' style={styles.img} source={img}/>
					<View style={styles.routes}>
						<Switch contextId="page">
							<Route exact path='/' component={Home} />
							<Route exact path='/PlaceOrder' component={PlaceOrder} />
							<Route exact path='/OrderConfirmation' component={OrderConfirmation} />
							<Route exact path='/MyOrders' component={MyOrders} />
							<Route component={NotFound} />
						</Switch>
					</View>
		</View>
	}

}

const styles = StyleSheet.create({
	header: {
		height: 60,
		justifyContent: 'flex-end',
	},
	headerText: {
		fontSize: 36,
		fontWeight: 'bold',
		textAlign: 'center',
		padding: 4,
		margin: 4
	},
	login: {
		padding: 8,
	},
	flex: {
		flex: 1
	},
	img: {
		height: 270,
		borderWidth: 1,
		zIndex: 0
	},
	links: {
		justifyContent: 'flex-end',
		flexWrap: 'wrap',
	},
	link: {
		margin: 8,
		padding: 8
	},
	routes: {
		flex: 1
	},
	menu: {
		position: 'absolute',
		backgroundColor: 'white',
		borderBottomWidth: 1,
		borderRightWidth: 1,
		borderColor: 'black',
		top: 60,
		//height: 100,
		zIndex: 2
	},
});

function mapStateToProps({data}) {
	const { account } = data;
	return {
        account: account
	}
}


