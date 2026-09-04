/* script.js */
const translations = {
  'en': {
    appTitle: 'CEP Finder',
    findHeading: 'Find CEP',
    resultHeading: 'Result',
    savedHeading: 'Saved CEPs',
    cepLabel: 'CEP',
    fetchBtn: 'Fetch',
    saveBtn: 'Save',
    clearBtn: 'Clear',
    savedEmpty: 'No saved CEPs',
    fetchSuccess: 'CEP fetched',
    fetchNotFound: 'CEP not found',
    savedOk: 'CEP saved',
    updatedOk: 'CEP updated',
    deletedOk: 'CEP deleted',
    invalidFormat: 'Invalid CEP format',
    developedby: 'Developed by Nivaldo Beirão'
  },
  'pt-BR': {
    appTitle: 'Buscador de CEP',
    findHeading: 'Buscar CEP',
    resultHeading: 'Resultado',
    savedHeading: 'CEPs Salvos',
    cepLabel: 'CEP',
    fetchBtn: 'Buscar',
    saveBtn: 'Salvar',
    clearBtn: 'Limpar',
    savedEmpty: 'Nenhum CEP salvo',
    fetchSuccess: 'CEP encontrado',
    fetchNotFound: 'CEP não encontrado',
    savedOk: 'CEP salvo',
    updatedOk: 'CEP atualizado',
    deletedOk: 'CEP excluído',
    invalidFormat: 'Formato de CEP inválido',
    developedby: 'Desenvolvido por Nivaldo Beirão'
  },
  'es': {
    appTitle: 'Buscador de CEP',
    findHeading: 'Buscar CEP',
    resultHeading: 'Resultado',
    savedHeading: 'CEPs Guardados',
    cepLabel: 'CEP',
    fetchBtn: 'Buscar',
    saveBtn: 'Guardar',
    clearBtn: 'Limpiar',
    savedEmpty: 'No hay CEPs guardados',
    fetchSuccess: 'CEP encontrado',
    fetchNotFound: 'CEP no encontrado',
    savedOk: 'CEP guardado',
    updatedOk: 'CEP actualizado',
    deletedOk: 'CEP eliminado',
    invalidFormat: 'Formato de CEP inválido',
    developedby: 'Desarrollado por Nivaldo Beirão'
  }
};

const elements = {
  title: document.getElementById('app-title'),
  langSelect: document.getElementById('lang-select'),
  themeToggle: document.getElementById('theme-toggle'),
  themeIcon: document.getElementById('theme-icon'),
  cepForm: document.getElementById('cep-form'),
  cepInput: document.getElementById('cep-input'),
  fetchBtn: document.getElementById('fetch-btn'),
  saveBtn: document.getElementById('save-btn'),
  clearBtn: document.getElementById('clear-btn'),
  status: document.getElementById('status'),
  resultList: document.getElementById('result-list'),
  savedList: document.getElementById('saved-list'),
  footerText: document.getElementById('footer-text')
};

let currentLang = localStorage.getItem('cep_lang') || 'en';
let currentTheme = localStorage.getItem('cep_theme') || 'dark';
let currentResult = null;
let editingId = null;

function applyTranslations() {
  const t = translations[currentLang];
  elements.title.textContent = t.appTitle;
  document.getElementById('search-heading').textContent = t.findHeading;
  document.getElementById('result-heading').textContent = t.resultHeading;
  document.getElementById('saved-heading').textContent = t.savedHeading;
  document.getElementById('cep-label').textContent = t.cepLabel;
  elements.fetchBtn.textContent = t.fetchBtn;
  elements.saveBtn.textContent = t.saveBtn;
  elements.clearBtn.textContent = t.clearBtn;
  elements.footerText.textContent = t.developedby;
  renderSavedList();
  renderResult(currentResult);
}

function applyTheme() {
  const root = document.documentElement;
  if (currentTheme === 'light') {
    root.classList.add('light');
    document.body.classList.remove('theme-dark');
    elements.themeToggle.setAttribute('aria-pressed', 'false');
    elements.themeIcon.innerHTML = sunSvg();
  } else {
    root.classList.remove('light');
    document.body.classList.add('theme-dark');
    elements.themeToggle.setAttribute('aria-pressed', 'true');
    elements.themeIcon.innerHTML = moonSvg();
  }
}

function moonSvg() {
  return `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" aria-hidden="true" focusable="false" xmlns="http://www.w3.org/2000/svg">
    <path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z" fill="currentColor"/>
  </svg>`;
}

function sunSvg() {
  return `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" aria-hidden="true" focusable="false" xmlns="http://www.w3.org/2000/svg">
    <path d="M6.76 4.84l-1.8-1.79L3.17 4.84l1.79 1.79 1.8-1.79zM1 13h3v-2H1v2zm10 9h2v-3h-2v3zM20.24 4.84l-1.79 1.79 1.8 1.79 1.79-1.79-1.8-1.79zM17 13a4 4 0 11-8 0 4 4 0 018 0zM4.22 19.78l1.79-1.79-1.8-1.79-1.79 1.79 1.8 1.79zM20 11v2h3v-2h-3zM19.78 19.78l-1.79-1.79-1.8 1.79 1.79 1.79 1.8-1.79z" fill="currentColor"/>
  </svg>`;
}

function showStatus(message, type = 'info') {
  elements.status.textContent = message;
  elements.status.style.color = type === 'error' ? getComputedStyle(document.documentElement).getPropertyValue('--danger') : getComputedStyle(document.documentElement).getPropertyValue('--success');
}

function clearStatus() {
  elements.status.textContent = '';
}

function sanitizeCep(input) {
  return input.replace(/\D/g, '').replace(/^(\d{5})(\d{3})$/, '$1-$2');
}

async function fetchCepFromViaCep(cep) {
  const sanitized = cep.replace(/\D/g, '');
  if (!/^\d{8}$/.test(sanitized)) {
    throw new Error(translations[currentLang].invalidFormat);
  }
  const url = `https://viacep.com.br/ws/${sanitized}/json/`;
  const res = await fetch(url, {cache: 'no-store'});
  if (!res.ok) throw new Error('Network error');
  const data = await res.json();
  if (data.erro) return null;
  return {
    cep: data.cep || '',
    street: data.logradouro || '',
    complement: data.complemento || '',
    neighborhood: data.bairro || '',
    city: data.localidade || '',
    state: data.uf || '',
    ibge: data.ibge || '',
    gia: data.gia || '',
    ddd: data.ddd || '',
    siafi: data.siafi || ''
  };
}

function renderResult(result) {
  elements.resultList.innerHTML = '';
  currentResult = result;
  if (!result) {
    return;
  }
  const t = translations[currentLang];
  showStatus(t.fetchSuccess, 'success');

  const entries = [
    ['CEP', result.cep],
    ['Street', result.street],
    ['Complement', result.complement],
    ['Neighborhood', result.neighborhood],
    ['City', result.city],
    ['State', result.state],
    ['IBGE', result.ibge],
    ['GIA', result.gia],
    ['DDD', result.ddd],
    ['SIAFI', result.siafi]
  ];

  entries.forEach(([k, v]) => {
    const dt = document.createElement('dt');
    dt.textContent = k;
    const dd = document.createElement('dd');
    dd.textContent = v || '-';
    elements.resultList.appendChild(dt);
    elements.resultList.appendChild(dd);
  });

  elements.saveBtn.disabled = false;
}

function loadSaved() {
  try {
    const raw = localStorage.getItem('cep_saved') || '[]';
    return JSON.parse(raw);
  } catch {
    return [];
  }
}

function saveSaved(list) {
  localStorage.setItem('cep_saved', JSON.stringify(list));
}

function renderSavedList() {
  const list = loadSaved();
  elements.savedList.innerHTML = '';
  const t = translations[currentLang];
  if (!list.length) {
    const li = document.createElement('li');
    li.className = 'saved-item';
    li.textContent = t.savedEmpty;
    elements.savedList.appendChild(li);
    return;
  }

  list.forEach(item => {
    const li = document.createElement('li');
    li.className = 'saved-item';
    li.setAttribute('data-id', item.id);

    const meta = document.createElement('div');
    meta.className = 'saved-meta';
    const title = document.createElement('div');
    title.textContent = `${item.cep} - ${item.city}/${item.state}`;
    title.style.fontWeight = '700';
    const subtitle = document.createElement('div');
    subtitle.textContent = item.street || '-';
    subtitle.style.color = 'var(--muted)';
    meta.appendChild(title);
    meta.appendChild(subtitle);

    const actions = document.createElement('div');
    actions.className = 'saved-actions';

    const editBtn = document.createElement('button');
    editBtn.className = 'icon-btn';
    editBtn.setAttribute('aria-label', 'Edit');
    editBtn.textContent = 'Edit';
    editBtn.addEventListener('click', () => startEdit(item.id));

    const deleteBtn = document.createElement('button');
    deleteBtn.className = 'icon-btn';
    deleteBtn.setAttribute('aria-label', 'Delete');
    deleteBtn.textContent = 'Delete';
    deleteBtn.addEventListener('click', () => removeSaved(item.id));

    actions.appendChild(editBtn);
    actions.appendChild(deleteBtn);

    li.appendChild(meta);
    li.appendChild(actions);
    elements.savedList.appendChild(li);
  });
}

function addSaved(item) {
  const list = loadSaved();
  const exists = list.find(i => i.cep === item.cep);
  if (exists) {
    // update existing
    list.splice(list.indexOf(exists), 1, item);
  } else {
    list.unshift(item);
  }
  saveSaved(list);
  renderSavedList();
}

function removeSaved(id) {
  const list = loadSaved().filter(i => i.id !== id);
  saveSaved(list);
  renderSavedList();
  showStatus(translations[currentLang].deletedOk, 'success');
}

function startEdit(id) {
  const list = loadSaved();
  const item = list.find(i => i.id === id);
  if (!item) return;
  editingId = id;
  elements.cepInput.value = item.cep;
  renderResult(item);
  showStatus(translations[currentLang].updatedOk, 'success');
}

function generateId() {
  return 'id-' + Math.random().toString(36).slice(2, 9);
}

/* Event handlers */
elements.langSelect.value = currentLang;
elements.langSelect.addEventListener('change', (e) => {
  currentLang = e.target.value;
  localStorage.setItem('cep_lang', currentLang);
  applyTranslations();
});

elements.themeToggle.addEventListener('click', () => {
  currentTheme = currentTheme === 'dark' ? 'light' : 'dark';
  localStorage.setItem('cep_theme', currentTheme);
  applyTheme();
});

elements.clearBtn.addEventListener('click', () => {
  elements.cepInput.value = '';
  currentResult = null;
  renderResult(null);
  elements.saveBtn.disabled = true;
  clearStatus();
});

elements.cepForm.addEventListener('submit', async (ev) => {
  ev.preventDefault();
  clearStatus();
  const raw = elements.cepInput.value.trim();
  const formatted = sanitizeCep(raw);
  elements.cepInput.value = formatted;
  try {
    const data = await fetchCepFromViaCep(formatted);
    if (!data) {
      showStatus(translations[currentLang].fetchNotFound, 'error');
      currentResult = null;
      renderResult(null);
      return;
    }
    renderResult(data);
  } catch (err) {
    showStatus(err.message || 'Error', 'error');
  }
});

elements.saveBtn.addEventListener('click', () => {
  if (!currentResult) return;
  const id = editingId || generateId();
  const item = Object.assign({ id }, currentResult);
  addSaved(item);
  editingId = null;
  elements.saveBtn.disabled = true;
  showStatus(translations[currentLang].savedOk, 'success');
});

/* Initialize */
(function init() {
  // Theme
  currentTheme = localStorage.getItem('cep_theme') || 'dark';
  applyTheme();

  // Language
  currentLang = localStorage.getItem('cep_lang') || 'en';
  elements.langSelect.value = currentLang;
  applyTranslations();

  // Load saved
  renderSavedList();

  // Accessibility: focus CEP input on load
  elements.cepInput.focus();
})();
