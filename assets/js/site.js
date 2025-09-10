(function(){
  function qsa(s){return Array.prototype.slice.call(document.querySelectorAll(s))}

  function applyFilter(tag){
    var chips = qsa('.chip');
    chips.forEach(function(c){ c.classList.toggle('active', c.dataset.topic === tag); });
    var cards = qsa('.grid .card, .featured-row .card');
    if(!tag){
      cards.forEach(function(card){ card.style.display = ''; });
      return;
    }
    cards.forEach(function(card){
      var tags = (card.getAttribute('data-tags') || '').split(',');
      var show = tags.map(function(s){return s.trim().toLowerCase();}).indexOf(tag.toLowerCase()) !== -1;
      card.style.display = show ? '' : 'none';
    });
  }

  // Wire chips
  qsa('.chip').forEach(function(btn){
    btn.addEventListener('click', function(){
      var topic = this.dataset.topic;
      var isActive = this.classList.contains('active');
      applyFilter(isActive ? '' : topic);
    });
  });

  // Optional: read ?tag= from URL
  var p = new URLSearchParams(window.location.search);
  if(p.get('tag')) applyFilter(p.get('tag'));
})();

document.addEventListener('scroll', () => {
  const h = document.querySelector('.site-header');
  if (!h) return;
  h.classList.toggle('is-scrolled', window.scrollY > 8);
});

/* =======================
   DARK MODE TOGGLE (inject into header nav safely)
   ======================= */
(function(){
  var root = document.documentElement;
  var key = 'theme'; // 'dark' | 'light'

  // Apply saved choice
  try {
    var saved = localStorage.getItem(key);
    if (saved === 'dark') root.classList.add('theme-dark');
    if (saved === 'light') root.classList.remove('theme-dark');
  } catch(e){ /* ignore storage issues */ }

  // Create button
  var btn = document.createElement('button');
  btn.id = 'theme-toggle';
  btn.className = 'theme-toggle';
  btn.type = 'button';
  btn.title = 'Toggle theme';
  btn.setAttribute('aria-label', 'Toggle dark mode');
  btn.textContent = root.classList.contains('theme-dark') ? '☀️' : '🌙';

  // Insert at end of .site-nav to avoid overlapping "Home"
  function mount(){
    var nav = document.querySelector('.site-header .site-nav');
    if (!nav) return;
    // Ensure it isn't duplicated
    if (!document.getElementById('theme-toggle')) {
      nav.appendChild(btn);
    }
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', mount);
  } else {
    mount();
  }

  // Toggle handler
  btn.addEventListener('click', function(){
    var isDark = root.classList.toggle('theme-dark');
    try { localStorage.setItem(key, isDark ? 'dark' : 'light'); } catch(e){}
    btn.textContent = isDark ? '☀️' : '🌙';
    btn.setAttribute('aria-label', isDark ? 'Switch to light mode' : 'Switch to dark mode');
  });
})();
