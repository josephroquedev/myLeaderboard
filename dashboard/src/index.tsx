import { AppProvider } from '@shopify/polaris';
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import './index.css';

ReactDOM.render(
    <AppProvider i18n={{}}>
        <App />
    </AppProvider>,
    document.getElementById('root'),
);
