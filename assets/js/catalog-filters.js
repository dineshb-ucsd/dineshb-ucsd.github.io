(function () {
  function splitValues(value) {
    if (!value) return [];
    return value
      .split(/\s+/)
      .map(function (entry) { return entry.trim(); })
      .filter(Boolean);
  }

  function setVisible(node, visible) {
    node.hidden = !visible;
    node.classList.toggle("is-hidden", !visible);
    if (visible) {
      node.style.removeProperty("display");
    } else {
      node.style.display = "none";
    }
  }

  function initCatalog(catalog) {
    if (!catalog || catalog.dataset.catalogReady === "true") return;

    var buttons = Array.prototype.slice.call(catalog.querySelectorAll("[data-filter-group][data-filter-value]"));
    var items = Array.prototype.slice.call(catalog.querySelectorAll("[data-catalog-item]"));
    var sections = Array.prototype.slice.call(catalog.querySelectorAll("[data-catalog-section]"));
    var countNode = catalog.querySelector("[data-catalog-count]");
    var state = {};

    catalog.dataset.catalogReady = "true";

    buttons.forEach(function (button) {
      var group = button.getAttribute("data-filter-group");
      if (!state[group] || button.classList.contains("is-active")) {
        state[group] = button.getAttribute("data-filter-value") || "all";
      }
    });

    function matches(item) {
      return Object.keys(state).every(function (group) {
        var selected = state[group];
        var values;

        if (!selected || selected === "all") return true;

        values = splitValues(item.getAttribute("data-catalog-" + group));
        return values.indexOf(selected) !== -1;
      });
    }

    function syncButtons() {
      buttons.forEach(function (button) {
        var group = button.getAttribute("data-filter-group");
        var value = button.getAttribute("data-filter-value") || "all";
        var isActive = state[group] === value;

        button.classList.toggle("is-active", isActive);
        button.setAttribute("aria-pressed", isActive ? "true" : "false");
      });
    }

    function syncItems() {
      var visibleCount = 0;

      items.forEach(function (item) {
        var visible = matches(item);
        setVisible(item, visible);
        if (visible) visibleCount += 1;
      });

      sections.forEach(function (section) {
        var hasVisible = Array.prototype.slice.call(section.querySelectorAll("[data-catalog-item]")).some(function (item) {
          return !item.hidden;
        });
        setVisible(section, hasVisible);
      });

      if (countNode) {
        countNode.textContent = visibleCount === 1 ? "Showing 1 item" : "Showing " + visibleCount + " items";
      }
    }

    buttons.forEach(function (button) {
      button.addEventListener("click", function () {
        var group = button.getAttribute("data-filter-group");
        var value = button.getAttribute("data-filter-value") || "all";

        state[group] = value;
        syncButtons();
        syncItems();
      });
    });

    syncButtons();
    syncItems();
  }

  function initAllCatalogs() {
    Array.prototype.slice.call(document.querySelectorAll("[data-catalog]")).forEach(initCatalog);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initAllCatalogs);
  } else {
    initAllCatalogs();
  }

  window.addEventListener("pageshow", initAllCatalogs);
})();
