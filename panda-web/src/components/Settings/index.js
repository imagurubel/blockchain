import React, { Component } from 'react';
import {
	View,
	Text,
	Button,
	FlatList,
	StyleSheet,
	TextInput
} from 'react-native';
import Hr from '../Hr';
import Cmd from '../Cmd';
import { connect } from 'react-redux';
import Row from '../Row';
import web3 from '../../web3';


class Settings extends Component {

	state = {
		form: false,
		address: '',
		privateKey: '',
		error: '',
		contract_address: ''
	}

	clear(){
		this.setState({
			form: false,
			contractForm: false,
			privateKey: '',
			address: '',
			contract_address: '',
		});
	}

	onCreateAccount(){
		const account = web3.eth.accounts.create();
		this.clear();
		this.props.dispatch({type: 'ACCOUNT', account: account});
		
	}

	onImportAccount(){
		
		try {
			const { address, privateKey } = this.state;
			const account = web3.eth.accounts.privateKeyToAccount(`0x${privateKey}`);
			if (account.address.toLowerCase() === address.toLowerCase()){
				this.clear();
				this.props.dispatch({type: 'ACCOUNT', account: account});

			}
		} catch (e){
			console.error(e);
		}

		
	}

	onSelectContract(){
		try {
			const { contract_address } = this.state;
			this.clear();
			this.props.dispatch({type: 'CONTRACT', address: contract_address});
		} catch(e){
			console.error(e);
		}
	}

	render(){
		const { form, contractForm, address, privateKey, contract_address } = this.state;
		const { contractAddress } = this.props;
		return <View>

				
				{!form && !contractForm && <View>

					<Cmd title={`Contract ${contractAddress}`} onPress={()=>this.setState({
						contractForm: true
					})} />
					<Cmd title={'Create new account'} onPress={this.onCreateAccount.bind(this)} />
					<Cmd title={'Import account'} onPress={()=>this.setState({
						form: true
					})} />

				</View>}

				{form && <View>
					<View style={styles.inputContainer}>
		                <Text style={styles.text}>Address</Text>
		                <TextInput
		                            style={[styles.input, styles.inputEditable]}
		                       
		                            value={address}
		                            returnKeyType={'done'}
		                   
		                            autoCorrect={false}
		                            autoCapitalize={'none'}
		                            placeholder={''}
		                            keyboardType={'default'}
		                            onChangeText={(address)=>this.setState({
										address: address
									})}
		                           

		                />
	                </View>

	                <View style={styles.inputContainer}>
		                <Text style={styles.text}>Private Key</Text>
		                <TextInput
		                            style={[styles.input, styles.inputEditable]}
		                     
		                            value={privateKey}
		                            returnKeyType={'done'}
		                            
		                            autoCorrect={false}
		                            autoCapitalize={'none'}
		                            placeholder={''}
		                            keyboardType={'default'}
		                            onChangeText={(privateKey)=>this.setState({
										privateKey: privateKey
									})}

		                />
	                </View>

	                <Row>
	                	<Button title={'CANCEL'} onPress={this.clear.bind(this)}/>
	                	<Button title={'DONE'} onPress={this.onImportAccount.bind(this)}/>
	                </Row>
				</View>}

				{contractForm && <View>

					<View style={styles.inputContainer}>
			                <Text style={styles.text}>Contract</Text>
			                <TextInput
			                            style={[styles.input, styles.inputEditable]}
			                     
			                            value={contract_address}
			                            returnKeyType={'done'}
			                            
			                            autoCorrect={false}
			                            autoCapitalize={'none'}
			                            placeholder={''}
			                            keyboardType={'default'}
			                            onChangeText={(contract_address)=>this.setState({
											contract_address: contract_address
										})}

			                />
		             </View>

		             <Row>
		               	<Button title={'CANCEL'} onPress={this.clear.bind(this)}/>
		               	<Button title={'DONE'} onPress={this.onSelectContract.bind(this)}/>
		            </Row>
		        </View>}

        </View>
	}
	
}

const styles = StyleSheet.create({
	contract_addressText: {
		borderRadius: 2,
	    backgroundColor: 'green',
	    color: 'white',
	    fontWeight: '500',
	    padding: 8,
	    margin: 4,
	    textAlign: 'left',
	    textTransform: 'uppercase',
	    backgroundColor: 'green'
	},
    input: {
    	margin: 4,
    	borderWidth: 1,
    	borderColor: 'rgba(0, 0, 0, 0.1)',
    	height: 31,
        width: 600,
        paddingLeft: 4,
        fontSize: 16,
        flex: 1,
        textAlign: 'left',
        justifyContent: 'center',
    },
    inputEditable: {
        backgroundColor: 'white'
    },
    text: {
    	marginLeft: 4,
    	marginRight: 4
    },
    inputContainer: {
    	marginTop: 8
    }
});

function mapStateToProps({data, dispatch}) {
	return {
        contractAddress: data.contractAddress
	}
}


export default connect(mapStateToProps)(Settings);