const initialState = {
	account: null,
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
