const btn = document.getElementById('load-more');
const grid = document.getElementById('posts-grid');

if (btn && grid) {
  const base = btn.dataset.baseurl || '';
  let current = parseInt(btn.dataset.currentPage || '1', 10);
  const total = parseInt(btn.dataset.totalPages || '1', 10);

  const setLoading = (on) => {
    btn.disabled = on;
    btn.textContent = on ? 'Loading…' : 'Read more';
  };

  const disable = () => {
    btn.disabled = true;
    btn.textContent = 'No more posts';
    btn.setAttribute('aria-disabled', 'true');
  };

  const pagePath = (n) => {
    // Jekyll pages follow /page/2/, /page/3/, etc.
    return `${base}/page/${n}/`.replace(/\/+/g, '/');
  };

  const appendFromPage = async (n) => {
    setLoading(true);
    try {
      const res = await fetch(pagePath(n), { credentials: 'same-origin' });
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      const html = await res.text();

      // Extract the same #posts-grid section from the next page
      const doc = new DOMParser().parseFromString(html, 'text/html');
      const nextGrid = doc.querySelector('#posts-grid');
      if (!nextGrid) throw new Error('Grid not found in next page');

      const cards = Array.from(nextGrid.children);
      if (!cards.length) {
        disable();
        return;
      }

      cards.forEach((el) => grid.appendChild(el));
      current = n;
      history.replaceState(null, '', `${location.pathname}?page=${current}`);
      if (current >= total) disable();
    } catch (err) {
      console.error('Load more failed:', err);
      btn.textContent = 'Retry';
      btn.disabled = false;
    } finally {
      if (!btn.disabled && current < total) setLoading(false);
    }
  };

  btn.addEventListener('click', () => {
    if (current >= total) return disable();
    appendFromPage(current + 1);
  });

  // If URL has ?page=N, preload up to that page (refresh persistence)
  const params = new URLSearchParams(location.search);
  const target = parseInt(params.get('page') || '1', 10);
  if (target > 1) {
    (async () => {
      for (let i = 2; i <= Math.min(target, total); i++) {
        await appendFromPage(i);
      }
    })();
  }

  if (total <= 1) disable();
}
