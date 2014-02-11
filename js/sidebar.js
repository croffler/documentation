---
layout: nil
---

var sidebar = {};

{% for cat in site.categories-list %}
sidebar["{{ cat }}"] = [];
{% for page in site.pages %}{% if page.categories == cat %}{% if page.parent != null %}
sidebar["{{ cat }}"].push({url:"{{ page.url }}", parent: "{{ page.parent }}", weight:{% if page.weight != null %} {{ page.weight }}{% else %} 0{% endif %}, title: "{{ page.title }}"});
{% endif %}{% endif %}{% endfor %}{% endfor %}


function addChildren(categoryName, categoryPages, parentUrl) {
  var tree = []; 
  var children = categoryPages.filter(function(x) {
    return (parentUrl == x.parent) ||
           (parentUrl == ("/" + categoryName.toLowerCase() + "/" + x.parent));
  });
  if (children == null || children.length == 0) return null; 
  for (var i=0; i<children.length; i++) {
    tree.push({"title":children[i].title, "url":children[i].url, "weight":children[i].weight, 
               "children":addChildren(categoryName, categoryPages, children[i].url)});
  }
  tree.sort(function(a,b) {
    return(a.weight - b.weight);
  });
  return tree; 
}

function makeSideBar(categoryName) {
  var tree = addChildren(categoryName, sidebar[categoryName], 'none');
  return treeToDom(tree);
}

function treeToDom(tree) {
  var rootUl = document.createElement("ul");
  $("#sidebar_menu").append(rootUl);
  appendChildrenToDom(rootUl, tree);
}

function appendChildrenToDom(currentDomElement, tree) {
  for (var i=0; i<tree.length; i++) {
    var li = document.createElement("li");
    var a = document.createElement("a");
    a.setAttribute("href", tree[i].url);
    li.appendChild(a);
    a.appendChild(document.createTextNode(tree[i].title));
    li.appendChild(a);
    currentDomElement.appendChild(li);
    if (tree[i].children) {
      var innerUl = document.createElement("ul");
      li.appendChild(innerUl);
      appendChildrenToDom(innerUl, tree[i].children);
    }
  }

}


function createBreadcrumbs(category, currentSection) {

  if (sidebar[category]) {
    var locations = [];
    var currentPath = location.pathname;
    var currentCrumb = sidebar[category].filter(function(x) {return x.url == currentPath})[0]
    while (currentCrumb) {
      locations.unshift(currentCrumb);
      if (currentCrumb.parent == "none") break;
      currentPath = "/" + category.toLowerCase() + "/" + currentCrumb.parent;
      currentCrumb = sidebar[category].filter(function(x) {return x.url == currentPath})[0]
    }
  }

  var breadcrumbsHtml = "<ol class='breadcrumb'>";
  breadcrumbsHtml += "<li><a href='/'>Home</a></li>";
  breadcrumbsHtml += "<li><a href='/" + category.toLowerCase() + "/'>" + currentSection + "</a></li>";
  if (locations.length > 0) {
    for (var i=0; i<locations.length; i++) {
      breadcrumbsHtml += "<li><a href='" + locations[i].url +"'>" + locations[i].title + "</a></li>";
    }
  }
  breadcrumbsHtml += "</ol>";
  $("#breadcrumbs").append(breadcrumbsHtml);

}




