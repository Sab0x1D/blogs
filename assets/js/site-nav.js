(function(){
  const toggle = document.getElementById('nav-toggle');
  const drawer = document.getElementById('mobile-drawer');
  if(!toggle || !drawer) return;

  const open = () => {
    drawer.classList.add('is-open');
    toggle.setAttribute('aria-expanded','true');
    toggle.setAttribute('aria-label','Close menu');
  };
  const close = () => {
    drawer.classList.remove('is-open');
    toggle.setAttribute('aria-expanded','false');
    toggle.setAttribute('aria-label','Open menu');
  };

  toggle.addEventListener('click',()=>{
    drawer.classList.contains('is-open') ? close() : open();
  });
  document.addEventListener('keydown',(e)=>{
    if(e.key==='Escape' && drawer.classList.contains('is-open')) close();
  });
  drawer.addEventListener('click',(e)=>{
    if(e.target.tagName==='A') close();
  });
})();
