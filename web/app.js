const stack = document.getElementById('stack');

const types = [
  'info',
  'success',
  'warning',
  'error'
];

const positions = new Set([
  // Top
  'top-left',
  'top-center',
  'top-right',

  // Center
  'center-left',
  'center-right',

  // Bottom
  'bottom-left',
  'bottom-center',
  'bottom-right',
]);

const pattern = /^[\w.-]+\.(ogg|mp3|wav)$/i;

const icons = {
  info: '<circle cx="12" cy="12" r="9"/><path d="M12 11v5M12 8h.01"/>',
  success: '<circle cx="12" cy="12" r="9"/><path d="M8 12.5l2.7 2.7L16 9.5"/>',
  warning: '<path d="M12 4l9 16H3z"/><path d="M12 10v4M12 17h.01"/>',
  error: '<circle cx="12" cy="12" r="9"/><path d="M9 9l6 6M15 9l-6 6"/>',
};

const defaultSound = 'click.ogg';

const state = {
  maxVisible: 5,
  volume: 0.5,
  sounds: {
    info: defaultSound,
    success: defaultSound,
    warning: defaultSound,
    error: defaultSound
  },
  titles: {
    info: 'Información',
    success: 'Éxito',
    warning: 'Aviso',
    error: 'Error'
  },
};

function applyConfig(config) {
  if (!config || typeof config !== 'object') return;
  if (positions.has(config.position)) stack.dataset.position = config.position;
  if (Number.isInteger(config.maxVisible) && config.maxVisible > 0) state.maxVisible = config.maxVisible;
  if (typeof config.volume === 'number') state.volume = Math.min(1, Math.max(0, config.volume));
  if (config.sounds) Object.assign(state.sounds, config.sounds);
  if (config.titles && typeof config.titles === 'object') {
    for (const type of types) {
      const title = config.titles[type];
      if (typeof title === 'string' && title !== '') state.titles[type] = title;
    }
  }

  if (config.colors) {
    for (const type of types) {
      const color = config.colors[type];
      if (typeof color === 'string' && /^#[0-9a-f]{3,8}$/i.test(color)) {
        document.documentElement.style.setProperty(`--${type}`, color);
      }
    }
  }
}

function playSound(type, custom) {
  if (state.volume <= 0) return;

  const file = typeof custom === 'string' && pattern.test(custom) ? custom : state.sounds[type];
  if (!file || !pattern.test(file)) return;

  try {
    const audio = new Audio(`sounds/${file}`);
    audio.volume = state.volume;
    audio.play().catch(() => {});
  } catch (_) {
    /* Audio should never interrupt a notification. */
  }
}

function createIcon(type) {
  const wrapper = document.createElement('div');
  wrapper.className = 'notify_icon';
  wrapper.innerHTML = `<svg viewBox="0 0 24 24" aria-hidden="true">${icons[type]}</svg>`;
  return wrapper;
}

function hideNotify(element) {
  if (!element.isConnected || element.classList.contains('is-leaving')) return;

  element.classList.add('is-leaving');
  setTimeout(() => element.remove(), 300);
}

function showNotify(data) {
  if (!data || typeof data.text !== 'string' || data.text === '') return;

  const type = types.includes(data.type) ? data.type : 'info';
  const duration = Number.isFinite(data.length) ? data.length : 5000;
  const title = typeof data.title === 'string' && data.title.trim() !== '' ? data.title : (state.titles[type] || type);

  const element = document.createElement('div');
  element.className = 'notify';
  element.dataset.type = type;
  element.style.setProperty('--duration', `${duration}ms`);

  const body = document.createElement('div');
  body.className = 'notify_body';

  const titleEl = document.createElement('span');
  titleEl.className = 'notify_title';
  titleEl.textContent = title;

  const textEl = document.createElement('span');
  textEl.className = 'notify_text';
  textEl.textContent = data.text;

  body.append(titleEl, textEl);

  const progress = document.createElement('div');
  progress.className = 'notify_progress';

  element.append(createIcon(type), body, progress);
  stack.append(element);

  const active = stack.querySelectorAll('.notify:not(.is-leaving)');
  if (active.length > state.maxVisible) hideNotify(active[0]);

  playSound(type, data.sound);
  setTimeout(() => hideNotify(element), duration);
}

window.addEventListener('message', (event) => {
  const message = event.data;
  if (!message || typeof message !== 'object') return;

  switch (message.action) {
    case 'config':
      applyConfig(message.data);
      break;
    case 'notify':
      showNotify(message.data);
      break;
    }
});

if (typeof GetParentResourceName === 'function') {
  fetch(`https://${GetParentResourceName()}/ready`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: '{}',
  }).catch(() => {});
}
