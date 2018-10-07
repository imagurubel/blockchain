import React from 'react';
import {
  	BrowserRouter as Router
} from 'react-router-dom';
import { AppRegistry } from 'react-native-web';
import App from './src/components/App';
import { name } from './app.json';
import { createStore, combineReducers } from 'redux';
import { Provider } from 'react-redux';
import 'isomorphic-fetch';
import reducers from './src/reducers';

const store = createStore(combineReducers(reducers));

const Element = ()=>(<Provider store={store}>
				<Router>
					<App/>
				</Router>
			</Provider>);

AppRegistry.registerComponent(name, () => Element);
AppRegistry.runApplication(name, {
	initialProps: {},
	rootTag: document.getElementById('root')
});