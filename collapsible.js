document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".collapsible-abstract").forEach((section) => {
    const toggle = section.querySelector(".abstract-toggle");
    const triangle = section.querySelector(".abstract-triangle");
    const content = section.querySelector(".abstract-content");

    if (!toggle || !triangle || !content) return;

    content.hidden = true;
    toggle.addEventListener("click", () => {
      const expanded = !content.hidden;
      content.hidden = expanded;
      toggle.setAttribute("aria-expanded", String(!expanded));
      triangle.textContent = expanded ? "▶" : "▼";
    });
  });
});
