import key from 'keymaster'
import React from 'react'
import { Provider } from 'react-redux'

import store from './store'
import Splashable from './Splashable'
import { getSelectedPara } from './selection'


console.log('Hello from SplashReader')


class SplashReader {
  init() {
    const splashable_wrapper = document.createElement('div')
    splashable_wrapper.setAttribute('id', 'splashreader--splashable-wrapper')
    document.body.appendChild(splashable_wrapper)

    console.log('store is', store, store.getState())
    React.render(
      <Provider store={store}>
        {() => <Splashable />}
      </Provider>,
      splashable_wrapper
    )

    // unsupported in Firefox etc
    // ref: http://stackoverflow.com/a/9035122/1048433
    document.addEventListener('selectionchange', this.handleSelection)
  }

  handleSelection(e) {
    key.unbind('space') // stop listening to old events

    let sel = window.getSelection()
    let para = getSelectedPara(sel)
    if ( para ) {
      store.dispatch({type: 'PARA_SELECTED'})
      key('space', (e, handler) => {
        e.preventDefault()
        splashPara(para)
        return false
      })
    } else {
      store.dispatch({type: 'PARA_DESELECTED'})
    }
  }

}

const splashReader = new SplashReader()
splashReader.init()


function splashPara(para) {
  if ( !para )
    return

  // TODO: actually the stuff
  para.style.backgroundColor = 'gold'

  let next_para = getNextSimilarSibling(para)
  console.log('got next para', next_para)
  setTimeout(splashPara.bind(null, next_para), 1000)
}



// null when last elem
function getNextSimilarSibling(para) {

  let next_elem = para
  while (true) {
    next_elem = next_elem.nextElementSibling
    if ( !next_elem ) {
      // end of the line; null
      break
    }
    if ( elemsAreSimilar(next_elem, para) ) {
      break
    }
  }

  return next_elem
}

function elemsAreSimilar(elemA, elemB) {
  // TODO: be fancier
  return ( elemA.nodeName === elemB.nodeName )
}
