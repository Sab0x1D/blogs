
/*! Sab0x1D theme toggle: light/dark with mobile default light */
(function(){
  var storageKey = 'sab0x1d-theme';

  function applyTheme(mode){
    document.documentElement.setAttribute('data-theme', mode);
    try { localStorage.setItem(storageKey, mode); } catch(e){}
    updateButton(mode);
  }

function currentTheme(){
  try {
    var saved = localStorage.getItem('sab0x1d-theme');
    if (saved) return saved;   // use the user's choice if they have one
  } catch(e){}
  return 'light';              // default: light on all devices
}


  var sun = '<svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M6.76 4.84l-1.8-1.79-1.41 1.41 1.79 1.8 1.42-1.42zm10.48 0l1.79-1.8 1.41 1.41-1.8 1.79-1.4-1.4zM12 4V1h0v3zm0 19v-3h0v3zM4 12H1v0h3zm22 0h-3v0h3zM6.76 19.16l-1.42 1.42-1.79-1.8 1.41-1.41 1.8 1.79zm10.48 0l1.4 1.4 1.8-1.79-1.41-1.41-1.79 1.8zM12 7a5 5 0 100 10 5 5 0 000-10z"/></svg>';
  var moon = '<svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"/></svg>';

  var btn;
  function updateButton(mode){
    if (!btn) return;
    btn.setAttribute('aria-label', mode === 'dark' ? 'Switch to light mode' : 'Switch to dark mode');
    btn.innerHTML = (mode === 'dark') ? moon : sun;
  }

  function ensureButton(){
    if (btn) return btn;
    btn = document.createElement('button');
    btn.className = 'theme-toggle';
    btn.type = 'button';
    document.addEventListener('keydown', function(e){
      if ((e.ctrlKey || e.metaKey) && e.key === 'j') {
        btn.click();
      }
    });
    var host = document.querySelector('.site-header .wrapper') || document.querySelector('.site-header') || document.body;
    host.appendChild(btn);
    btn.addEventListener('click', function(){
      var next = (document.documentElement.getAttribute('data-theme') === 'dark') ? 'light' : 'dark';
      applyTheme(next);
    });
    return btn;
  }

  // Initialize
  ensureButton();
  applyTheme(currentTheme());

  // React to OS scheme changes if user hasn't set a preference
  try {
    var mql = window.matchMedia('(prefers-color-scheme: dark)');
    mql.addEventListener('change', function(){
      var saved = localStorage.getItem(storageKey);
      if (!saved) applyTheme(currentTheme());
    });
  } catch(e){}
})();
