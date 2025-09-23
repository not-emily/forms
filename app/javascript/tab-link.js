// On page load, check for URL hash and activate corresponding tab
document.addEventListener('DOMContentLoaded', () => {
  const hash = window.location.hash;
  if (hash) {
    const triggerEl = document.querySelector(`.nav[role="tablist"] button[data-bs-target="${hash}"]`);
    if (triggerEl) {
      bootstrap.Tab.getOrCreateInstance(triggerEl).show();
    }
  }

  // Update URL hash when a tab is shown
  const tabButtons = document.querySelectorAll('.nav[role="tablist"] button[data-bs-toggle="tab"]');
  tabButtons.forEach(button => {
    button.addEventListener('shown.bs.tab', (e) => {
      if (history.pushState) {
        history.pushState(null, null, e.target.getAttribute('data-bs-target'));
      } else {
        // Fallback for older browsers
        window.location.hash = e.target.getAttribute('data-bs-target');
      }
    });
  });
});
