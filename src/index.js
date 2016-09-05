/* @flow */
import 'babel-polyfill'  // for regenerator
import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'

import store from './flux/store'
import SplashApp from './components/SplashApp'
import * as dom from './lib/dom'
import * as ranges from './lib/ranges'
import * as events from './lib/events'
import { loadWpmFromChrome, listenForPlay } from './lib/splash'


const init = async () => {
  await ranges.waitForRangy()

  const wrapper = dom.insertWrapper()

  await loadWpmFromChrome()
  listenForPlay()
  events.listenForSpace()

  ReactDOM.render(
    <Provider store={store}>
      <SplashApp />
    </Provider>,
    wrapper
  )
}

init()
