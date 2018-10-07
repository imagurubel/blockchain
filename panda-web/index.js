import React from 'react';
import {
  NativeRouter as Router
} from 'react-router-native';
import { AppRegistry } from 'react-native';
import App from './src/components/App';
import { name } from './app.json';

import ApolloClient from 'apollo-client';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { HttpLink } from 'apollo-link-http';
import { ApolloProvider } from "react-apollo";
import { apiUri } from './config';

const Element = ()=>(<ApolloProvider client={new ApolloClient({
			link: new HttpLink({
			  	uri: apiUri,
			  	credentials: 'same-origin'
			}),
			cache: new InMemoryCache()
		})}>
			<Router>
				<App/>
			</Router>
</ApolloProvider>);

AppRegistry.registerComponent(name, () => Element);