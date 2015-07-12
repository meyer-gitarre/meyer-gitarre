module.exports =
class Page
  constructor: (@name, @path, @parent, @sections, @children, @important) ->
    @sections ?= []
    @children ?= []
    @important ?= []

  directChild: (pname, pnames) ->
    page = child for child in @.children when child.name is pname

    if not page?
      console.error "error on pageHierarchy #{pnames}"
      console.error 'no child for this name exists:'
      console.error pname
      process.exit 1

    return page

  recursiveChild: (pnames) ->
    tmp = this
    tmp = tmp.directChild(pname, pnames) for pname in pnames
    return tmp

  @parsePage: (page, parent) ->
    parsedPage = new Page(page.name, page.path, parent, page.sections, [], [])

    if page.children?
      for c in page.children
        parsedPage.children.push(Page.parsePage(c, parsedPage))

    if page.important?
      for i in page.important
        parsedPage.important.push(Page.parsePage(i, parsedPage))

    return parsedPage

  @parse: (ms) ->
    return Page.parsePage(ms, null)
