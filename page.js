// Generated by CoffeeScript 1.9.3
(function() {
  var Page;

  module.exports = Page = (function() {
    function Page(name, path, parent1, sections, children) {
      this.name = name;
      this.path = path;
      this.parent = parent1;
      this.sections = sections;
      this.children = children;
      if (this.sections == null) {
        this.sections = [];
      }
      if (this.children == null) {
        this.children = [];
      }
    }

    Page.prototype.directChild = function(pname) {
      var child, i, len, page, ref;
      ref = this.children;
      for (i = 0, len = ref.length; i < len; i++) {
        child = ref[i];
        if (child.name === pname) {
          page = child;
        }
      }
      if (page == null) {
        console.error('no child for this name exists:');
        console.error(pname);
        process.exit(1);
      }
      return page;
    };

    Page.prototype.recursiveChild = function(pnames) {
      var i, len, pname, tmp;
      tmp = this;
      for (i = 0, len = pnames.length; i < len; i++) {
        pname = pnames[i];
        tmp = tmp.directChild(pname);
      }
      return tmp;
    };

    Page.parsePage = function(page, parent) {
      var c, i, len, parsedPage, ref;
      parsedPage = new Page(page.name, page.path, parent, page.sections, []);
      if (page.children != null) {
        ref = page.children;
        for (i = 0, len = ref.length; i < len; i++) {
          c = ref[i];
          parsedPage.children.push(Page.parsePage(c, parsedPage));
        }
      }
      return parsedPage;
    };

    Page.parse = function(ms) {
      var menu;
      menu = Page.parsePage(ms, null);
      return menu;
    };

    return Page;

  })();

}).call(this);