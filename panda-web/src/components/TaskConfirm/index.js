import React, { Component } from 'react';
import {
	View,
	Text,
	Button,
	Switch,
	TextInput,
	StyleSheet,
	FlatList
} from 'react-native';

import Row from '../Row';
import Select from '../Select';
import Cmd from '../Cmd';
import Indicator from '../Indicator';
import { withRouter } from 'react-router-native';
import Header from '../Header';
import { connect } from 'react-redux';
import web3, { contract } from '../../web3';
import sha256 from 'sha256';
import Hr from '../Hr';
import { ADDRESSES, MIN_SERVICE_FEE } from '../../constants';


const inWei = (value)=>{
		return Number((Number(value) * 1000000000000000000).toFixed(0));
}
class PlaceOrder extends Component {
	state = {
		address: '',
		loading: false,
		taskId: '',
		value: '1',
		lastHash: ''
	}

	onChangeTerm(textValue){

		this.setState({
				taskId: textValue
		});
	}

	onChangeValue(textValue){

		this.setState({
			value: textValue
		});
	}

	onChangePreformerAddress(text){
		this.setState({
			address: text
		});
	}


	onSubmit(){
		const { history, account, contractAddress, dispatch } = this.props;
		const { address, taskId, value } = this.state;

		this.setState({
			loading: true
		}, ()=>{

				let tx_builder = contract.methods.taskConfirm(
					Number(taskId)
				);

				let transactionObject = {
				    gas: 4000000,
				    data: tx_builder.encodeABI(),
				    from: account.address,
				    to: contractAddress,
				    gasPrice: 4,
				    value: inWei(value)
				};

				web3.eth.accounts.signTransaction(transactionObject, account.privateKey)
				.then((signedTx)=>{
					return web3.eth.sendSignedTransaction(signedTx.rawTransaction).once('transactionHash', (transactionHash)=>{
						this.setState({
								loading: false,
								value: '0',
								address: '',
								taskId: '0',
								lastHash: transactionHash
							});
						})
				})
				.catch( (e)=>{
					this.setState({
						loading: false
					});
					console.log(e);
				})


		});


	}



	get formDisabled(){
		const { contractAddress, account } = this.props;
		const { fromLangIndex, toLangIndex, text, address, fromLangEdit, toLangEdit, loading, taskId, value } = this.state;

		if ( taskId=='' ||
			inWei(value) <= MIN_SERVICE_FEE ||
			!account ||
			address.length == 0 ||
			loading ||
			!contractAddress
		){
			return true;
		}
		return false;
	}

	render(){


		const { fromLangIndex, fromLangEdit, toLangIndex, toLangEdit, price, loading, text, taskId, address, value, lastHash } = this.state;
		const { account } = this.props;

		return <Row style={styles.main}>

			<View style={[styles.flex, {height: 410}, styles.cell]}>

					<Header title={'Select your new clients'} />
					<FlatList
						data={ADDRESSES.concat(ADDRESSES, ADDRESSES).reverse().filter((performer)=>!account || performer!=account.address)}
						renderItem={({item, index})=>{
							return <Cmd title={item} onPress={()=>this.setState({ address: item })} />
						}}
						keyExtractor={(item, index)=>String(index)}
					/>

			</View>
			<View style={[styles.flex, styles.cell]}>

					<Header title={'Confirm your new work'} />

					<View style={styles.inputContainer}>
		                <Text style={styles.text}>Customer address</Text>
		                <TextInput
		                            style={[styles.input, loading && styles.inputLoading || styles.inputEditable]}
		                            value={address}
		                            returnKeyType={'done'}
		                            editable={!loading}
		                            autoCorrect={false}
		                            autoCapitalize={'none'}
		                            placeholder={''}
		                            keyboardType={'default'}
		                            onChangeText={this.onChangePreformerAddress.bind(this)}

		                />
	                </View>

	                <View style={styles.inputContainer}>
		                <Text style={styles.text}>Task id</Text>
		                <TextInput
		                            style={[styles.input, loading && styles.inputLoading || styles.inputEditable]}
		                            returnKeyType={'done'}
		                            value={taskId}
		                            editable={!loading}
		                            autoCorrect={false}
		                            autoCapitalize={'none'}
		                            placeholder={'0'}
		                            keyboardType={'numeric'}
		                            onChangeText={this.onChangeTerm.bind(this)}

		                />
	                </View>

	                <View style={styles.inputContainer}>
		                <View><Text style={styles.text}>Value</Text></View>
		                <TextInput
		                            style={[styles.input, loading && styles.inputLoading || styles.inputEditable]}
		                            returnKeyType={'done'}
		                            value={value}
		                            editable={!loading}
		                            autoCorrect={false}
		                            autoCapitalize={'none'}
		                            placeholder={'0'}
		                            keyboardType={'numeric'}
		                            onChangeText={this.onChangeValue.bind(this)}

		                />
	                </View>

	                <View style={styles.inputContainer}>
	                	{loading && <Indicator title={'loading...'} /> || <Button disabled={this.formDisabled} title="SEND TRANSACTION" onPress={this.onSubmit.bind(this)}/>}
	                </View>

	                <Text style={styles.hashText}>
	                	{lastHash}
	                </Text>
	            </View>

        </Row>
	}
}


const styles = StyleSheet.create({
	main: {
		justifyContent: 'space-evenly',
		alignItems: 'flex-start',
		flex: 1
	},
	cell: {
		marginLeft: 20,
		marginRight: 20
	},
	flex: {flex:1},
	langView: {
		justifyContent: 'flex-start'
	},
    input: {
    	margin: 4,
    	borderWidth: 1,
    	borderColor: 'rgba(0, 0, 0, 0.1)',
    	height: 31,

        paddingLeft: 4,
        fontSize: 16,
        flex: 1,
        textAlign: 'left',
        justifyContent: 'center',
    },
    inputEditable: {
        backgroundColor: 'white'
    },
   	inputLoading: {
        backgroundColor: 'rgba(0, 0, 0, 0.1)',
    },
    hashText: {
    	margin: 4,
    	padding: 4
    },
    text: {
    	marginLeft: 4,
    	marginRight: 4
    },
    inputContainer: {
    	marginTop: 8,
    	width: 400
    }
});
const mapStateToProps = ({data, dispatch}) => {
	return {
        account: data.account,
        contractAddress: data.contractAddress,
	}
}
export default withRouter( connect(mapStateToProps)(PlaceOrder) );
