
// assumes para validated by oneParaSelected
export function getSelectedPara(sel) {
  let { anchorNode, focusNode, anchorOffset } = sel

  if (anchorOffset !== 0) {
    console.log('selection does not begin at para start', anchorOffset)
    return false
  }

  let target_string = sel.toString()
  let para_node = getParaBeforeNode(focusNode, target_string)

  return para_node
}


// recursive
// TODO: rename, cleanup
function getParaBeforeNode(node, target_string) {
  // when whole para is highlighted,
  // `focusNode` contains the first text after the paragrah

  if ( !node ) {
    console.log('no Node')
    return false
  }

  if ( node.textContent ) {
    if ( node.textContent.trim() === target_string.trim() ) {
      console.log('node has the right text', node, target_string)
      return node
    }
    console.log('wrong text', node.textContent, target_string)
  } else {
    console.log('empty node')
  }

  if ( node.previousElementSibling ) {
    console.log('going to previous sibling', node.previousElementSibling)
    return getParaBeforeNode(node.previousElementSibling, target_string)
  }
  if ( node.parentElement ) {
    console.log('going to parent', node.parentElement)
    return getParaBeforeNode(node.parentElement, target_string)
  }

  console.log('couldnt find paraBeforeNode')
  return null
}
