// /assets/js/load-more.js
const btn  = document.getElementById('load-more');
const grid = document.getElementById('posts-grid');

if (btn && grid) {
  const base    = btn.dataset.baseurl || '';
  let current   = parseInt(btn.dataset.currentPage || '1', 10);
  const total   = parseInt(btn.dataset.totalPages || '1', 10);
  const chunk   = parseInt(btn.dataset.chunkSize || '3', 10) || 3;
  const pageCap = 9; // number of posts per page (your paged.html templates)

  let buffer = [];
  let bufferedPageNum = null;

  const setLoading = (on) => {
    if (on) {
      btn.classList.add('loading');
      btn.disabled = true;
      btn.textContent = 'Loading…';
    } else {
      btn.classList.remove('loading');
      btn.disabled = false;
      btn.textContent = 'Read more';
    }
  };

  const disable = () => {
    btn.classList.remove('loading');
    btn.disabled = true;
    btn.textContent = 'No more posts';
    btn.setAttribute('aria-disabled', 'true');
  };

  const pagePath = (n) => `${base}/page/${n}/`.replace(/\/+/g, '/');

  const fetchPageIntoBuffer = async (n) => {
    const res = await fetch(pagePath(n), { credentials: 'same-origin' });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const html = await res.text();
    const doc  = new DOMParser().parseFromString(html, 'text/html');
    const nextGrid = doc.querySelector('#posts-grid');
    if (!nextGrid) throw new Error('Grid not found in next page');
    const nodes = Array.from(nextGrid.children);
    buffer = nodes;
    bufferedPageNum = n;
  };

  const appendChunk = (count) => {
    const take = Math.min(count, buffer.length);
    for (let i = 0; i < take; i++) grid.appendChild(buffer.shift());
    return take;
  };

  const revealNextChunk = async () => {
    // Refill buffer if empty and pages remain
    if (buffer.length === 0) {
      const nextPageToFetch = current + 1;
      if (nextPageToFetch > total) {
        disable();
        return;
      }
      await fetchPageIntoBuffer(nextPageToFetch);
      if (buffer.length === 0) {
        current = bufferedPageNum;
        if (current >= total) disable();
        return;
      }
    }

    // Append next `chunk` items
    appendChunk(chunk);

    // If we’ve emptied the current page buffer, advance the page tracker
    if (buffer.length === 0) {
      current = bufferedPageNum;
      history.replaceState(null, '', `${location.pathname}?page=${current}`);
    }

    // Determine next state
    if (current >= total && buffer.length === 0) {
      disable();
    } else {
      setLoading(false); // ✅ reset every time a chunk finishes
    }
  };

  btn.addEventListener('click', async () => {
    if (btn.disabled) return;
    setLoading(true);
    try {
      await revealNextChunk();
    } catch (e) {
      console.error('Load more failed:', e);
      btn.classList.remove('loading');
      btn.textContent = 'Retry';
      btn.disabled = false;
    }
  });

  // Restore ?page=N state
  const params = new URLSearchParams(location.search);
  const target = parseInt(params.get('page') || '1', 10);
  if (target > 1) {
    setLoading(true);
    (async () => {
      try {
        for (let n = 2; n <= Math.min(target, total); n++) {
          await fetchPageIntoBuffer(n);
          appendChunk(buffer.length);
          buffer = [];
          bufferedPageNum = null;
          current = n;
        }
      } catch (e) {
        console.error('Reconstruct failed:', e);
      } finally {
        if (current >= total) disable();
        else setLoading(false);
      }
    })();
  }

  if (total <= 1) disable();
}
