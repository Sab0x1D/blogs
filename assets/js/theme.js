(function () {
  var KEY = 'theme';
  var root = document.documentElement;

  function apply(t) {
    if (t === 'dark') root.setAttribute('data-theme', 'dark');
    else root.removeAttribute('data-theme'); // default = light
  }

  // Always default to light unless a user saved a choice
  var t = localStorage.getItem(KEY);
  if (t !== 'dark' && t !== 'light') {
    t = 'light';
    localStorage.setItem(KEY, t);
  }
  apply(t);

  // Toggle if a button exists
  var btn = document.getElementById('theme-toggle');
  if (btn) {
    btn.addEventListener('click', function () {
      t = (root.getAttribute('data-theme') === 'dark') ? 'light' : 'dark';
      localStorage.setItem(KEY, t);
      apply(t);
    });
  }
})();
