const initialState = {
	account: {
		address: '0x8c5f0fA05F2c9e750578a6291E4D791821C53519',
		privateKey: '0xc87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3'
	},
	contractAddress: '0xf12b5dd4ead5f743c6baa640b0216200e89b60da'
}

const dataReducer = (state = initialState, action)=>{


	switch(action.type){
		case 'CONTRACT':
			state = {
					...state,
					contractAddress: action.address
			}
		break;
		case 'ACCOUNT':
			state = {
					...state,
					account: action.account
			}

		break;
	}

	console.log(state);

	return state;
}


const reducers = {
 	data: dataReducer
};

export default reducers;
