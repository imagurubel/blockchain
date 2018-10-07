import React, { Component } from 'react';
import {
	View,
	Text,
	Button,
	Switch,
	TextInput,
	StyleSheet,
	ScrollView,
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
import MyOrders from '../MyOrders';
import Hr from '../Hr';

const LANGUAGES = ['English', 'Русский'];
const MIN_SERVICE_FEE = 10000000000000000;
const inWei = (value)=>{
		return Number((Number(value) * 1000000000000000000).toFixed(0));
}
class PlaceOrder extends Component {
	state = {
		fromLangIndex: 0,
		toLangIndex: 1,
		fromLangEdit: false,
		toLangEdit: false,
		text: `Где то, что ничего, которое вокруг?
Оно исчезло вдруг, с тех пор и нет его...
Где то, чего и нет? Везде нигде оно!
Оно везде, где нет того, что ничего!`,
		address: '0xf17f52151ebef6c7334fad080c5704d77216b732',
		loading: false,
		duration: '60',
		value: '1',
		lastHash: ''
	}

	onChangeTerm(textValue){

		this.setState({
				duration: Number(textValue).toFixed(0)
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

	onChangeText(text){
		this.setState({
			text: text
		});
	}

	onSubmit(){
		const { history, account, contractAddress, dispatch } = this.props;
		const { text, address, duration, value } = this.state;

		this.setState({
			loading: true
		}, ()=>{
			
				let tx_builder = contract.methods.taskCreate(
					Array.from(Buffer.from(sha256(text), 'hex')),
					address,
					duration
				);

				let encoded_tx = tx_builder.encodeABI();

				let transactionObject = {
				    gas: 4000000,
				    data: encoded_tx,
				    from: account.address,
				    to: contractAddress,
				    gasPrice: 4,
				    value: inWei(value)
				};

				web3.eth.accounts.signTransaction(transactionObject, account.privateKey, (error, signedTx) =>{
					if (error) {
						console.error(error);
	    			} else {
    					web3.eth.sendSignedTransaction(signedTx.rawTransaction).once('transactionHash',  (transactionHash) => {
    					
            				this.setState({
									loading: false,
									text: '',
									value: '0',
									address: '',
									duration: '0',
									lastHash: transactionHash
							});
            				
        				});
    				}
					
    			});
	

		});

		
	}



	get formDisabled(){
		const { contractAddress } = this.props;
		const { fromLangIndex, toLangIndex, text, address, fromLangEdit, toLangEdit, loading, duration, value } = this.state;

		if (fromLangIndex == toLangIndex){
			return true;
		}

		if (text.length == 0){
			return true;
		}

		if (!(Number(duration) > 0)){
			return true;
		}

		if (inWei(value) <= MIN_SERVICE_FEE ){
			return true;
		}

		if (address.length == 0){
			return true;
		}

		if (fromLangEdit || toLangEdit){
			return true;
		}

		if (loading){
			return true;
		}

		if (!contractAddress){
			return true;
		}
	
		return false;
	}

	render(){


		const { fromLangIndex, fromLangEdit, toLangIndex, toLangEdit, price, loading, text, duration, address, value, lastHash } = this.state;
		const { placedTasks } = this.props;

		return <View>
			
			<Header title={'Place your order'} />
		
			<View style={styles.form}>
			

				<Row style={styles.langView}>
					{!fromLangEdit && <Cmd disabled={loading} title={LANGUAGES[fromLangIndex]} onPress={()=>this.setState({fromLangEdit: true})}/> || <Select
						data={LANGUAGES}
						selectedIndex={fromLangIndex}
						onDone={(index)=>this.setState({fromLangEdit: false, fromLangIndex: index})}
						onCancel={()=>this.setState({fromLangEdit: false})}
					/>}
					<Text> -> </Text>
					{!toLangEdit && <Cmd disabled={loading} title={LANGUAGES[toLangIndex]} onPress={()=>this.setState({toLangEdit: true})}/> || <Select
						data={LANGUAGES}
						selectedIndex={toLangIndex}
						onDone={(index)=>this.setState({toLangEdit: false, toLangIndex: index})}
						onCancel={()=>this.setState({toLangEdit: false})}
					/>}
				</Row>

				<View style={styles.inputContainer}>
	                <Text style={styles.text}>Performer address</Text>
	                <TextInput
	                            style={[styles.input, loading && styles.inputLoading || styles.inputEditable]}
	                            //multiline={true}
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
	                <Text style={styles.text}>duration</Text>
	                <TextInput
	                            style={[styles.input, loading && styles.inputLoading || styles.inputEditable]}
	                            returnKeyType={'done'}
	                            value={duration}
	                            editable={!loading}
	                            autoCorrect={false}
	                            autoCapitalize={'none'}
	                            placeholder={'0'}
	                            keyboardType={'numeric'}
	                            onChangeText={this.onChangeTerm.bind(this)}

	                />
                </View>

                <View style={styles.inputContainer}>
	                <View><Text style={styles.text}>Value ({inWei(value)} wei)</Text></View>
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
	                <Text style={styles.text}>Text to translate</Text>
	                <TextInput
	                            style={[styles.input, loading && styles.inputLoading || styles.inputEditable, {height: 50}]}
	                            multiline={true}
	                            value={text}
	                            returnKeyType={'done'}
	                            editable={!loading}
	                            autoCorrect={false}
	                            autoCapitalize={'none'}
	                            placeholder={''}
	                            keyboardType={'default'}
	                            onChangeText={this.onChangeText.bind(this)}

	                />
                </View>

                <View style={styles.inputContainer}>
                	{loading && <Indicator title={'loading...'} /> || <Button disabled={this.formDisabled} title="SEND TRANSACTION" onPress={this.onSubmit.bind(this)}/>}
                </View>

                <Text style={styles.hashText}>
                	{lastHash}
                </Text>
            </View>

		</View>
	}
}


const styles = StyleSheet.create({
	img: {
		//width: 200,
		height: 50,
		borderWidth: 1,
	},
	hashes: {
		width: 550,
	},
	twoColumns: {
		justifyContent: 'space-evenly',
		alignItems: 'flex-start'
	},
	flex: {flex:1},
	langView: {
		justifyContent: 'flex-start'
	},
	form: {
		alignSelf: 'center',
		borderColor: 'rgba(0, 0, 0, 0.1)',
	},
    input: {
    	margin: 4,
    	borderWidth: 1,
    	borderColor: 'rgba(0, 0, 0, 0.1)',
    	height: 31,
        width: 400,
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
    	marginTop: 8
    }
});
const mapStateToProps = ({data, dispatch}) => {
	return {
        account: data.account,
        contractAddress: data.contractAddress,
        placedTasks: data.placedTasks
	}
}
export default withRouter( connect(mapStateToProps)(PlaceOrder) );