(function () {
  var STORAGE_KEY = 'theme'; // 'light' or 'dark'
  var root = document.documentElement;
  var mql = window.matchMedia('(prefers-color-scheme: dark)');

  function apply(theme) {
    if (theme === 'dark') {
      root.setAttribute('data-theme', 'dark');
    } else {
      root.removeAttribute('data-theme'); // default = light
    }
  }

  function getInitialTheme() {
    var saved = localStorage.getItem(STORAGE_KEY);
    if (saved === 'light' || saved === 'dark') return saved;
    // fallback to OS preference
    return mql.matches ? 'dark' : 'light';
  }

  // Initial paint
  apply(getInitialTheme());

  // Wire a toggle button if present (id="theme-toggle")
  var btn = document.getElementById('theme-toggle');
  if (btn) {
    btn.addEventListener('click', function () {
      var current = root.getAttribute('data-theme') === 'dark' ? 'dark' : 'light';
      var next = current === 'dark' ? 'light' : 'dark';
      localStorage.setItem(STORAGE_KEY, next);
      apply(next);
    });
  }

  // If user hasn't set a theme, follow OS changes live
  if (!localStorage.getItem(STORAGE_KEY) && mql.addEventListener) {
    mql.addEventListener('change', function (e) {
      apply(e.matches ? 'dark' : 'light');
    });
  }
})();
