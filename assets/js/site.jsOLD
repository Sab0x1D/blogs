
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
