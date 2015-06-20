module.exports =
class Page
  constructor: (@name, @path, @parent, @sections, @children, @important) ->
    @sections ?= []
    @children ?= []
    @important ?= []

  directChild: (pname) ->
    page = child for child in @.children when child.name is pname

    if not page?
      console.error('no child for this name exists:')
      console.error(pname)
      process.exit(1)

    return page

  recursiveChild: (pnames) ->
    tmp = @
    tmp = tmp.directChild(pname) for pname in pnames
    return tmp

  @parsePage: (page, parent) ->
    parsedPage = new Page(page.name, page.path, parent, page.sections, [], [])

    if page.children?
      parsedPage.children.push(Page.parsePage(c, parsedPage)) for c in page.children

    if page.important?
      parsedPage.important.push(Page.parsePage(i, parsedPage)) for i in page.important

    return parsedPage

  @parse: (ms) ->
    menu = Page.parsePage(ms, null)

    return menu
