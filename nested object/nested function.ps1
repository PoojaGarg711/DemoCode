const searchTerm = "britania"
let result = []

function getEachItem {
    param([object]$object )
  object.forEach(item => {
    searchItem(item)
  })
  let uniqueResults = [...new Set(result)]
  return uniqueResults
}

function searchItem {
    param([object]$item)

  Object.keys($item).forEach($key => {
    if (typeof $item[$key] -eq 'object') {
      searchItem($item[$key])
    }
    if (typeof $item[$key] -eq 'string') {
      let searchAsRegEx = new RegExp($searchTerm, "gi");
      if (item[key].match(searchAsRegEx)) {
        result.push(item.id)
      }
    }
  })
}