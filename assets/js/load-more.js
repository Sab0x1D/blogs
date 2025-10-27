// /assets/js/load-more.js
const btn  = document.getElementById('load-more');
const grid = document.getElementById('posts-grid');

if (btn && grid) {
  const base    = btn.dataset.baseurl || '';
  let current   = parseInt(btn.dataset.currentPage || '1', 10);   // last fully-loaded page index (page 1 already on screen)
  const total   = parseInt(btn.dataset.totalPages || '1', 10);
  const chunk   = parseInt(btn.dataset.chunkSize || '3', 10) || 3; // 3 per click by default
  const pageCap = 9; // each paginated page contains 9 cards in your templates

  // Buffer holds nodes fetched from the NEXT page but not yet appended
  let buffer = [];
  let bufferedPageNum = null; // which page 'buffer' belongs to

  const setLoading = (on) => {
    btn.disabled = on;
    btn.textContent = on ? 'Loading…' : 'Read more';
  };

  const disable = () => {
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
    buffer = nodes;               // up to 9 (or fewer on last page)
    bufferedPageNum = n;
  };

  const appendChunk = (count) => {
    const take = Math.min(count, buffer.length);
    for (let i = 0; i < take; i++) grid.appendChild(buffer.shift());
    return take;
  };

  const revealNextChunk = async () => {
    // make sure there’s something in the buffer; if not and there are more pages, fetch the next page
    if (buffer.length === 0) {
      const nextPageToFetch = current + 1;
      if (nextPageToFetch > total) {
        disable();
        return;
      }
      await fetchPageIntoBuffer(nextPageToFetch);
      // If the fetched page is empty (shouldn’t happen unless miscount), bail
      if (buffer.length === 0) {
        current = bufferedPageNum; // consider it consumed
        if (current >= total) disable();
        return;
      }
    }

    // Append up to `chunk` cards from the buffer
    appendChunk(chunk);

    // If we exhausted the buffer, we’ve fully revealed bufferedPageNum => update URL & state
    if (buffer.length === 0) {
      current = bufferedPageNum;
      history.replaceState(null, '', `${location.pathname}?page=${current}`);
      if (current >= total) disable();
    }
  };

  btn.addEventListener('click', async () => {
    if (btn.disabled) return;
    setLoading(true);
    try {
      await revealNextChunk();
    } catch (e) {
      console.error('Load more failed:', e);
      btn.textContent = 'Retry';
      btn.disabled = false;
      return;
    } finally {
      if (!btn.disabled && current < total) setLoading(false);
    }
  });

  // If user lands with ?page=N, reconstruct by fully loading pages 2..N
  const params = new URLSearchParams(location.search);
  const target = parseInt(params.get('page') || '1', 10);
  if (target > 1) {
    (async () => {
      setLoading(true);
      try {
        for (let n = 2; n <= Math.min(target, total); n++) {
          await fetchPageIntoBuffer(n);
          // append full page (all available cards) for reconstruction
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

  // If there’s only one page total, no need to show the button
  if (total <= 1) disable();
}
