const fs = require("fs");
const path = require("path");

const mstructure = require("./menustructure.json");

function escape_html(input) {
  return input.replace(/["]/g, (char) => {
    switch (char) {
      case `"`:
        return "&quot;";
    }
  });
}

function preprocess_entry(entry) {
  if (!entry.children) {
    entry.children = [];
  }
  if (!entry.important) {
    entry.important = [];
  }
  if (!entry.sections) {
    entry.sections = [];
  }

  entry.children.forEach((x) => preprocess_entry(x));
  entry.important.forEach((x) => preprocess_entry(x));
  entry.sections.forEach((x) => preprocess_entry(x));
};

preprocess_entry(mstructure);

function find_child(menu_structure, name) {
  let cchild = undefined;
  menu_structure.children.forEach((child) => {
    if (child.name === name) {
      cchild = child;
    }
  })
  if (cchild) {
    return cchild;
  } else {
    throw "child not found";
  }
}

function get_entry(location) {
  if (!location) {
    return mstructure;
  }
  let current = mstructure;
  location.forEach((name) => {
    current = find_child(current, name);
  });
  return current;
}

function get_parent_entry(location) {
  const new_location = [...location];
  new_location.pop();
  return get_entry(new_location);
}

function get_ancestors(location) {
  let current_location = [];
  const ancestors = [get_entry(current_location)];

  if (!location) {
    return [mstructure];
  }

  location.forEach((name) => {
    current_location.push(name);
    ancestors.push(get_entry(current_location));
  });

  return ancestors;
}

function render_additional_styles(additional_styles) {
  let additional_styles_rendered = "";
  if (additional_styles) {
    additional_styles.forEach((name) => {
      additional_styles_rendered += `\n    <link rel='stylesheet' href='/stylesheets/${name}.css' type='text/css'>`;
    })
  }
  return additional_styles_rendered;
};

function render_color(menu_structure) {
  if (menu_structure) {
    switch (menu_structure[0]) {
      case "Blockflöte": return "bflColor";
      case "Gitarre": return "gitColor";
      case "Musiklehre": return "musColor";
      default: return "defaultColor";
    }
  } else {
    return "defaultColor";
  }
};

function render_link(p, clazz) {
  if (p) {
    return `<a${clazz ? ` class="${clazz}"` : ""} href="${p.path}">${!clazz ? `${p.name}` : ""}</a>`;
  } else {
    return "";
  }
};

function render_ordered_list(clazz, entries) {
  if (entries.length === 0) {
    return "";
  }

  let lis = "";
  entries.forEach((entry) => { lis += `<li>${entry}</li>` });
  return `<ol${clazz ? ` class="${clazz}"` : ""}>${lis}</ol>`;
};

function render_breadcrumbs(menu_structure) {
  const entries = [];
  get_ancestors(menu_structure).forEach((page) => {
    const children = [];
    page.children.forEach((child) => { children.push(render_link(child)) });
    entries.push(`${render_link(page)}${render_ordered_list(null, children)}`);
  });
  return render_ordered_list("breadcrumbs", entries);
};

function render_menu_entry(clazz, p) {
  const lis = [];
  if (p.children && p.children.length > 0) {
    p.children.forEach((child) => { lis.push(render_menu_entry(null, child)) });
  } else {
    if (p.sections && p.sections.length > 0) {
      p.sections.forEach((section) => { lis.push(render_menu_entry(null, section)) });
    }
  }
  return `${render_link(p)}${render_ordered_list(clazz, lis)}`;
};

function render_importants(menu_structure) {
  const importants = [];
  const p = get_entry(menu_structure);

  // Bei Home Seite sind die importants gehardcoded.
  if (p === mstructure) {
    const homeImps = [
      {
        name: "Stichworte",
        path: "/gitarre/index.html#stichwortverzeichnisgitarre",
        sections: [
          {
            name: "Gitarre",
            path: "/gitarre/index.html#stichwortverzeichnisgitarre",
          },
          {
            name: "Musiklehre",
            path: "/musiklehre/index.html#stichwortverzeichnismusik",
          },
          {
            name: "Blockflöte",
            path: "/blockfloete/index.html#stichwortverzeichnisbfl",
          },],
      },
      {
        name: "Musikschultermine",
        path: "/musiklehre/musik-text/musikschule/index.html#termine",
      },
    ];
    homeImps.forEach((homeImp) => { importants.unshift(render_menu_entry(null, homeImp)) });
  }

  get_ancestors(menu_structure).forEach((page) => {
    if (page.important && page.important.length > 0) {
      page.important.forEach((imp) => {
        const r = render_menu_entry(null, imp);
        if (importants.indexOf(r) < 0) {
          let flag = p.name !== imp.name;
          p.children.forEach((child) => {
            if (child.name === imp.name) {
              flag = false;
            }
          });
          if (flag) {
            importants.unshift(r);
          }
        }
      });
    }
  });

  if (importants.length === 0) {
    return "";
  } else {
    return render_ordered_list("important", importants);
  }
};

function render_menu_default(menu_structure) {
  const p = get_entry(menu_structure);
  return `<div class="menu">${render_menu_entry(null, p)}${render_importants(menu_structure)}</div>`;
}

function render_sitemap() {
  return `<section>
  	<h3 id="map">Sitemap</h3>
    <div id="sitemap" class="clearfix">
      <div>${render_menu_entry(null, get_entry(["Gitarre"]))}</div>
      <div>${render_menu_entry(null, get_entry(["Musiklehre"]))}</div>
      <div>${render_menu_entry(null, get_entry(["Blockflöte"]))}</div>
    </div>
  </section>
  <section>
  	<h3 id="struktur">Struktur</h3>
  	<p>
  		Die "Hauptseiten"
  		<strong>Gitarre und Musiklehre</strong> verzweigen sich weiter auf
  		<strong>Themen-Startseiten</strong>. Von diesen aus geht es weiter auf die Folgeseiten mit den einzelnen Kapiteln. <strong>Blockflöte</strong> hat selbst direkte Folgeseiten.</p>
  		<p>Am Anfang und am Ende jeder Seite finden sich Links zur vorherigen "<b><span class="blue">↩</span></b>" und zur folgenden "<b><span class="blue">↪</span></b>" Seite, damit man quasi vor- und zurückblättern kann.
  	</p>
  	<p>
  		Es gibt <a href="/musiklehre/index.html#stichwortverzeichnismusik">Stichworte</a> zu den Hauptseiten und eine <a href="#wrapper">Suche</a>, die über einen externen Server läuft und anzeigt, ob und auf welcher Seite ein Begriff vorkommt. Auf der gefundenen
  		Seite müssten Sie dann die Suchfunktion Ihres Browsers (strg+f) benutzen.</p>
  </section>`;
};

function render_link_previous_page(menu_structure) {
  const p = get_entry(menu_structure);
  if (!menu_structure) {
    menu_structure = [];
  }
  const threshold = menu_structure[0] === "Blockflöte" ? 1 : 2;

  if (menu_structure.length > threshold) {
    const parent = get_parent_entry(menu_structure);
    let previous_sibling = undefined;
    parent.children.forEach((sib) => {
      if (parent.children.indexOf(sib) + 1 === parent.children.indexOf(p)) {
        previous_sibling = sib;
      }
    });
    return render_link(previous_sibling ? previous_sibling : parent, "prevPage");
  } else {
    return "";
  }
};

function render_link_next_page(menu_structure) {
  const p = get_entry(menu_structure);
  if (!menu_structure) {
    menu_structure = [];
  }
  const threshold = menu_structure[0] === "Blockflöte" ? 1 : 2;

  if (menu_structure.length === threshold) {
    if (p.children && p.children.length > 0) {
      return render_link(p.children[0], "nextPage");
    }
  }

  if (menu_structure.length > threshold) {
    const parent = get_parent_entry(menu_structure);
    let next_sibling = undefined;
    parent.children.forEach((sib) => {
      if (parent.children.indexOf(sib) - 1 === parent.children.indexOf(p)) {
        next_sibling = sib;
      }
    });
    return render_link(next_sibling ? next_sibling : parent, "nextPage");
  } else {
    return "";
  }
};

function render_badger(data) {
  const title = data.title;
  if ((data.menuStructure && data.menuStructure.length > 1) || title === "Impressum" || title === "Sitemap" || title === "Datenschutz") {
    return `<div class='exBorder floatedRight imageWrapper img200'>
              <a href='/index.html'>
                <img src='/img/Dachsgr1.jpg' alt='Gitarrendachs'>
              </a>
            </div>`;
  } else {
    return `<div class='exBorder floatedRight imageWrapper img280'>
              <a href='/index.html'>
                <img src='/img/Dachsgr1.jpg' alt='Gitarrendachs'>
              </a>
            </div>`;
  }
}

function render_mini_menu(menu_structure) {
  let menu = "";
  switch (menu_structure ? menu_structure[0] : "default") {
    case "Blockflöte":
      menu = `<li><a href="/blockfloete/index.html">Blockflöte</a></li><li><a href="/blockfloete/index.html#stichwortverzeichnisbfl">Stichworte</a></li>`;
      break;
    case "Musiklehre":
      menu = `<li><a href="/musiklehre/index.html">Musiklehre</a></li><li><a href="/musiklehre/index.html#stichwortverzeichnismusik">Stichworte</a></li>`;
      break;
    case "Gitarre":
      menu = `<li><a href="/gitarre/index.html">Gitarre</a></li><li><a href="/gitarre/index.html#stichwortverzeichnisgitarre">Stichworte</a></li>`;
      break;
    default:
      menu = `<li><a href="/gitarre/index.html">Gitarre</a></li><li><a href="/musiklehre/index.html">Musiklehre</a></li><li><a href="/blockfloete/index.html">Blockflöte</a></li><li><a href="/meta/sitemap/index.html">Sitemap</a></li>`;
      break;
  }
  return `<ul><li><a href="/index.html">Home</a></li>${menu}</ul>`;
}

function render_main_template(inner, data) {
  return `<!DOCTYPE html>
<html lang='de'>
  <head>
    <meta charset='utf-8'>
    <meta name='description' content='${data.description}'>
    <meta name='revisit-after' content='14days'>
    <meta name='author' content='Ulrich Meyer'>
    <title>
      U.Meyer ${data.title}
    </title>
    <link rel='stylesheet' href='/stylesheets/main.css' type='text/css'>${render_additional_styles(data.additionalStyles)}
    <link rel='shortcut icon' href='/img/dachsicon.jpg'>
  </head>
  <body>
    <div class='${render_color(data.menuStructure)}' id='wrapper'>
      <header id='mainHeader'>
        <h1>
          Gitarre und Musiklehre, U. Meyer
        </h1>
      </header>
      <nav class='clearfix' id='mainNav'>
        <div class='clearfix navbar'>
          ${render_breadcrumbs(data.menuStructure)}
          <form id='search' action='http://www.crawl-it.de/registration/search.it'>
            <input type='text' name='p_search' size='15'>
            <input type='submit' value='Search'>
            <input type='hidden' name='p_userid' value='526047'>
              <a href='http://www.crawl-it.de/registration/search.it?p_userid=526047&p_service=NEW'></a>
          </form>
        </div>
        <div id='containerMenuCaption'>
          <div id='menuContainer'>
            ${render_menu_default(data.menuStructure)}
          </div>
          <div class='caption'>
            <div class='clearfix'></div>
            ${render_badger(data)}
            ${data.intro}
          </div>
        </div>
      </nav>
      <main>
        <div class='navContext series'>
          <div>
            ${render_link_previous_page(data.menuStructure)}
          </div>
          <div>
            ${render_link_next_page(data.menuStructure)}
          </div>
        </div>
        ${inner}
        <div class='navContext series'>
          <div>
            ${render_link_previous_page(data.menuStructure)}
          </div>
          <div>
            ${render_link_next_page(data.menuStructure)}
          </div>
        </div>
      </main>
      <footer id='mainFooter'>
        <div>
          <a href='/index.html'>
            Home
          </a>
          <a href='/gitarre/index.html'>
            Gitarre
          </a>
          <a href='/musiklehre/index.html'>
            Musiklehre
          </a>
          <a href='/blockfloete/index.html'>
            Blockflöte
          </a>
          <a href='/meta/impressum/index.html'>
            Impressum
          </a>
          <a href='/meta/datenschutz/index.html'>
            Datenschutz
          </a>
          <a href='/meta/sitemap/index.html'>
            Sitemap
          </a>
          <a href='#'>
            oben
          </a>
        </div>
        <p>
          <a rel="license" href="https://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://licensebuttons.net/l/by/4.0/80x15.png" /></a>This work is licensed under a <a rel="license" href="https://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.
        </p>
      </footer>
      <div id='miniMenuWrapper'>
        <div id='miniMenu'>
          ${render_mini_menu(data.menuStructure)}
          <a href='#'></a>
        </div>
      </div>
    </div>
  </body>
</html>
`;
};

function ensure_directory_existence(filePath) {
  let dirname = path.dirname(filePath);
  if (fs.existsSync(dirname)) {
    return true;
  }
  ensure_directory_existence(dirname);
  fs.mkdirSync(dirname);
}


const getAllFiles = function(dirPath, arrayOfFiles) {
  files = fs.readdirSync(dirPath)

  arrayOfFiles = arrayOfFiles || []

  files.forEach(function(file) {
    if (fs.statSync(dirPath + "/" + file).isDirectory()) {
      arrayOfFiles = getAllFiles(dirPath + "/" + file, arrayOfFiles)
    } else {
      arrayOfFiles.push(path.join(__dirname, dirPath, "/", file))
    }
  })

  return arrayOfFiles
}

function copy_files(filenames) {
  filenames.forEach((filename) => {
    if (path.extname(filename) !== "") {
      if (fs.lstatSync(filename).isFile()) {
        const to_copy = fs.readFileSync(filename);
        new_filename = filename.replace(/\/source\//, '/build/');
        ensure_directory_existence(new_filename);
        fs.writeFileSync(new_filename, to_copy);
      }
    }
  });
}

function separate_frontmatter(input) {
  const regexp = /^[\s]*<!--([\s\S]*?)-->([\s\S]*)/g;
  const match = regexp.exec(input);
  if (match) {
    return {
      frontmatter: match[1],
      content: match[2],
    };
  } else {
    return {
      frontmatter: "{}",
      content: input,
    };
  }
}

const all_sources = getAllFiles("source", []);
all_sources.forEach((filename) => {
  if (path.extname(filename) === ".html") {
    const inner = fs.readFileSync(filename, "utf8");

    const data = separate_frontmatter(inner);
    const frontmatter = JSON.parse(data.frontmatter);
    const content = data.content;

    frontmatter.title = escape_html(frontmatter.title);
    frontmatter.description = escape_html(frontmatter.description);
    frontmatter.intro = escape_html(frontmatter.intro);

    let rendered = render_main_template(content, frontmatter);
    new_filename = filename.replace(/\/source\//, '/build/');
    ensure_directory_existence(new_filename);
    fs.writeFileSync(new_filename, rendered);
  }
});

const sitemap_frontmatter = {
  title: 'Sitemap',
  description: 'Sitemap der Seite \'Ulrich Meyer, Gitarre und Musiklehre\'.',
  menuStructure: ['Sitemap'],
  additionalStyles: ['sitemap'],
  intro: '<h2>Sitemap</h2> <p>Eine Auflistung aller Seiten, Unterseiten und Kapitel</p>',
};
ensure_directory_existence('build/meta/sitemap/index.html');
fs.writeFileSync('build/meta/sitemap/index.html', render_main_template(render_sitemap(), sitemap_frontmatter));

copy_files(getAllFiles("source/img/", []));
copy_files(getAllFiles("source/midi/", []));
copy_files(getAllFiles("source/mp3/", []));
copy_files(getAllFiles("source/pdf/", []));
copy_files(getAllFiles("source/stylesheets/", []));
copy_files(getAllFiles("source/akkordetool/", []));

const htaccess = fs.readFileSync("source/.htaccess");
ensure_directory_existence("build/.htaccess");
fs.writeFileSync("build/.htaccess", htaccess);

ensure_directory_existence("build/akkordetool/img/gtak/a6.jpg");
getAllFiles("source/img/gtak", []).forEach((filename) => {
  const img = fs.readFileSync(filename);
  fs.writeFileSync(`build/akkordetool/img/gtak/${path.basename(filename)}`, img);
});
