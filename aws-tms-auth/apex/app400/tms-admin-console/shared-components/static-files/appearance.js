/* In-place appearance LOV. Native APEX per-user preference; no page/region reload. */
(function () {
  "use strict";
  apex.jQuery(function () {
    if (String(apex.env.APP_ID) !== "400") { return; }
    var picker, changing = false;
    var nativeStyle = /\/Vita(?:-Dark)?(?:\.min)?\.css(?:[?#]|$)/;
    function themeLink(doc) {
      return Array.from(doc.querySelectorAll('link[rel="stylesheet"]')).find(function (link) {
        return nativeStyle.test(link.href);
      });
    }
    function applicationDocuments(doc, result) {
      result.push(doc);
      Array.from(doc.querySelectorAll("iframe")).forEach(function (frame) {
        try {
          var child = frame.contentDocument;
          var app = child && child.getElementById("pFlowId");
          if (app && app.value === "400" && child.body && themeLink(child)) {
            applicationDocuments(child, result);
          }
        } catch (ignore) { /* Cross-origin frames are outside this application. */ }
      });
      return result;
    }
    function prepareStyle(doc, value) {
      return new Promise(function (resolve, reject) {
        var oldLink = themeLink(doc);
        if (!oldLink) { reject(new Error("Native theme stylesheet not found")); return; }
        var href = oldLink.href.replace(/\/Vita(?:-Dark)?(?=(?:\.min)?\.css(?:[?#]|$))/, value === "dark" ? "/Vita-Dark" : "/Vita");
        var plan = { doc: doc, oldLink: oldLink, link: null, x: doc.defaultView.scrollX, y: doc.defaultView.scrollY };
        if (href === oldLink.href) { resolve(plan); return; }
        var link = doc.createElement("link");
        var timer;
        plan.link = link;
        link.rel = "stylesheet";
        link.media = "not all";
        link.href = href;
        function clear() {
          window.clearTimeout(timer);
          link.onload = null;
          link.onerror = null;
        }
        link.onload = function () { clear(); resolve(plan); };
        link.onerror = function () {
          clear(); link.remove(); reject(new Error("Theme stylesheet could not be loaded"));
        };
        timer = window.setTimeout(link.onerror, 15000);
        // Preserve the cascade order: native theme before application/page styles.
        oldLink.parentNode.insertBefore(link, oldLink.nextSibling);
      });
    }
    function savePreference(value) {
      return new Promise(function (resolve, reject) {
        apex.server.process("TMS_SET_APPEARANCE", { x01: value }, { dataType: "json" })
          .done(function (result) {
            if (result && result.ok) { resolve(); }
            else { reject(new Error("Appearance preference could not be saved")); }
          })
          .fail(function () { reject(new Error("Appearance preference could not be saved")); });
      });
    }
    async function changeAppearance(value) {
      var current = document.body.classList.contains("tms-dark-mode") ? "dark" : "light";
      if (changing) { picker.value = current; return; }
      if (value === current || (value !== "light" && value !== "dark")) { return; }
      var plans = [];
      changing = true;
      picker.disabled = true;
      try {
        var docs = applicationDocuments(document, []);
        for (var doc of docs) { plans.push(await prepareStyle(doc, value)); }
        await savePreference(value);
        plans.forEach(function (plan) {
          if (plan.link) {
            plan.link.media = plan.oldLink.media || "all";
            plan.oldLink.remove();
          }
          plan.doc.body.classList.toggle("tms-dark-mode", value === "dark");
          plan.doc.body.classList.toggle("tms-modern-finance", value === "light");
          plan.doc.body.classList.toggle("apex-theme-dark-mode", value === "dark");
          plan.doc.defaultView.scrollTo(plan.x, plan.y);
        });
        picker.value = value;
      } catch (error) {
        plans.forEach(function (plan) { if (plan.link) { plan.link.remove(); } });
        picker.value = current;
        apex.message.alert("Appearance could not be changed. Please try again.");
      } finally {
        changing = false;
        picker.disabled = false;
      }
    }
    var userButton = document.getElementById("app-user") || document.getElementById("L4000311");
    var userEntry = userButton && userButton.closest("li");
    if (!userEntry || document.getElementById("tms-appearance-picker")) { return; }
    var entry = document.createElement("li");
    entry.className = "t-NavigationBar-item tms-appearance-entry";
    var label = document.createElement("label");
    label.htmlFor = "tms-appearance-picker";
    label.className = "u-VisuallyHidden";
    label.textContent = "Appearance";
    picker = document.createElement("select");
    picker.id = "tms-appearance-picker";
    picker.setAttribute("aria-label", "Appearance");
    [["light", "Light mode"], ["dark", "Dark mode"]].forEach(function (choice) {
      var option = document.createElement("option");
      option.value = choice[0]; option.textContent = choice[1]; picker.appendChild(option);
    });
    picker.value = document.body.classList.contains("tms-dark-mode") ? "dark" : "light";
    picker.addEventListener("change", function () { changeAppearance(picker.value); });
    entry.appendChild(label); entry.appendChild(picker);
    userEntry.parentNode.insertBefore(entry, userEntry);
  });
}());
