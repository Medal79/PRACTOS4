const STORAGE_KEY = 'cs2_tasks_v1';
let tasks = [], dragId = null, editId = null;

const COLUMNS = ['todo', 'inprogress', 'review', 'testing', 'done'];
const PRIORITY_ORDER = { high: 0, medium: 1, low: 2 };
const PRIORITY_LABEL = { high: 'Высокий', medium: 'Средний', low: 'Низкий' };

function uid() { return Math.random().toString(36).slice(2) + Date.now().toString(36); }

function loadTasks() {
    try { tasks = JSON.parse(localStorage.getItem(STORAGE_KEY)) || []; }
    catch { tasks = []; }
    if (!tasks.length) tasks = defaultTasks();
}

function saveTasks() { localStorage.setItem(STORAGE_KEY, JSON.stringify(tasks)); }

function defaultTasks() {
    const n = Date.now();
    return [
        { id: uid(), col: 'todo',       priority: 'high',   category: 'Игроки',    title: 'Обновить профиль s1mple',                  desc: 'Статистика за последний сезон BLAST Premier.',    createdAt: n - 9000 },
        { id: uid(), col: 'todo',       priority: 'medium', category: 'Турниры',   title: 'Добавить PGL Major Copenhagen',             desc: 'Призовой фонд, участники, сетка.',               createdAt: n - 8000 },
        { id: uid(), col: 'inprogress', priority: 'high',   category: 'Матчи',     title: 'Разобрать демо NaVi vs Vitality',           desc: 'Экономика раундов и позиционирование.',          createdAt: n - 7000 },
        { id: uid(), col: 'inprogress', priority: 'medium', category: 'Новости',   title: 'Написать новость о переходе ZywOo',         desc: 'Условия трансфера и реакция фанатов.',           createdAt: n - 6000 },
        { id: uid(), col: 'review',     priority: 'high',   category: 'Аналитика', title: 'Рейтинг топ-10 AWP-игроков CS2 2025',      desc: 'Учитывать рейтинг HLTV и импакт в турнирах.',   createdAt: n - 5000 },
        { id: uid(), col: 'review',     priority: 'low',    category: 'Игроки',    title: 'Карточка donk из Team Spirit',              desc: 'Биография, достижения, сильные стороны.',        createdAt: n - 4000 },
        { id: uid(), col: 'testing',    priority: 'medium', category: 'Турниры',   title: 'Проверить расписание IEM Cologne 2025',     desc: 'Даты групп, формат сетки, список команд.',       createdAt: n - 3000 },
        { id: uid(), col: 'testing',    priority: 'low',    category: 'Новости',   title: 'Тест публикации результатов матчей',        desc: 'Проверить парсинг и отображение счёта.',         createdAt: n - 2000 },
        { id: uid(), col: 'done',       priority: 'high',   category: 'Матчи',     title: 'Итоги финала ESL Pro League S21',           desc: 'Счёт, MVP, статистика, лучшие моменты.',         createdAt: n - 1500 },
        { id: uid(), col: 'done',       priority: 'medium', category: 'Аналитика', title: 'Win-rate команд на Inferno за 6 месяцев',  desc: 'Данные за BLAST и ESL. Инфографика готова.',     createdAt: n - 500  },
    ];
}

function escHtml(s) {
    return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

function formatDate(ts) {
    return new Date(ts).toLocaleDateString('ru-RU', { day: '2-digit', month: 'short', year: 'numeric' });
}

function getFiltered() {
    const cat    = document.getElementById('filter-cat').value;
    const search = document.getElementById('filter-search').value.trim().toLowerCase();
    const sort   = document.getElementById('sort-by').value;

    let list = tasks.filter(t => {
        if (cat && t.category !== cat) return false;
        if (search && !t.title.toLowerCase().includes(search) && !(t.desc || '').toLowerCase().includes(search)) return false;
        return true;
    });

    list.sort((a, b) => {
        if (sort === 'date-asc')  return a.createdAt - b.createdAt;
        if (sort === 'date-desc') return b.createdAt - a.createdAt;
        if (sort === 'priority')  return PRIORITY_ORDER[a.priority] - PRIORITY_ORDER[b.priority];
        if (sort === 'title')     return a.title.localeCompare(b.title, 'ru');
        return 0;
    });

    return list;
}

function renderBoard() {
    const filtered = getFiltered();
    COLUMNS.forEach(col => {
        const body     = document.getElementById('body-' + col);
        const cnt      = document.getElementById('cnt-'  + col);
        const colTasks = filtered.filter(t => t.col === col);
        cnt.textContent = colTasks.length;
        body.innerHTML  = '';

        if (!colTasks.length) {
            body.innerHTML = '<div class="empty-col">Нет задач</div>';
            return;
        }

        colTasks.forEach((t, i) => {
            const card = document.createElement('div');
            card.className  = 'task-card' + (i % 2 === 1 ? ' card-alt' : '');
            card.draggable  = true;
            card.dataset.id = t.id;
            card.innerHTML  = `
                <div class="task-actions">
                    <button onclick="openEdit('${t.id}')">Изменить</button>
                    <button onclick="deleteTask('${t.id}')">Удалить</button>
                </div>
                <div class="task-title">${escHtml(t.title)}</div>
                <div class="task-meta">${escHtml(t.category)}</div>
                <div class="task-meta">${formatDate(t.createdAt)}</div>
                ${t.desc ? `<div class="task-desc">${escHtml(t.desc)}</div>` : ''}
                <span class="task-priority p-${t.priority}">${PRIORITY_LABEL[t.priority]}</span>
            `;
            card.addEventListener('dragstart', e => onDragStart(e, t.id));
            card.addEventListener('dragend', onDragEnd);
            body.appendChild(card);
        });
    });
    document.getElementById('total-counter').textContent = 'Всего задач: ' + filtered.length;
}

function addTask() {
    const title = document.getElementById('inp-title').value.trim();
    if (!title) { notify('Введите название задачи!', true); return; }
    tasks.unshift({
        id: uid(), title,
        category:  document.getElementById('inp-category').value,
        priority:  document.getElementById('inp-priority').value,
        col:       document.getElementById('inp-col').value,
        desc:      document.getElementById('inp-desc').value.trim(),
        createdAt: Date.now(),
    });
    saveTasks(); renderBoard();
    document.getElementById('inp-title').value = '';
    document.getElementById('inp-desc').value  = '';
    notify('Задача добавлена');
}

function deleteTask(id) {
    tasks = tasks.filter(t => t.id !== id);
    saveTasks(); renderBoard();
    notify('Задача удалена');
}

function openEdit(id) {
    const t = tasks.find(x => x.id === id);
    if (!t) return;
    editId = id;
    document.getElementById('m-title').value    = t.title;
    document.getElementById('m-category').value = t.category;
    document.getElementById('m-priority').value = t.priority;
    document.getElementById('m-col').value      = t.col;
    document.getElementById('m-desc').value     = t.desc || '';
    document.getElementById('modal-overlay').classList.add('open');
}

function closeModal() {
    document.getElementById('modal-overlay').classList.remove('open');
    editId = null;
}

function saveEdit() {
    const t = tasks.find(x => x.id === editId);
    if (!t) return;
    const title = document.getElementById('m-title').value.trim();
    if (!title) { notify('Введите название задачи!', true); return; }
    t.title    = title;
    t.category = document.getElementById('m-category').value;
    t.priority = document.getElementById('m-priority').value;
    t.col      = document.getElementById('m-col').value;
    t.desc     = document.getElementById('m-desc').value.trim();
    saveTasks(); renderBoard(); closeModal();
    notify('Задача обновлена');
}

document.getElementById('modal-overlay').addEventListener('click', e => {
    if (e.target === e.currentTarget) closeModal();
});

function onDragStart(e, id) {
    dragId = id;
    e.dataTransfer.effectAllowed = 'move';
    setTimeout(() => document.querySelector(`.task-card[data-id="${id}"]`)?.classList.add('dragging'), 0);
}

function onDragEnd() {
    dragId = null;
    document.querySelectorAll('.task-card').forEach(c => c.classList.remove('dragging'));
    document.querySelectorAll('.column').forEach(c => c.classList.remove('drag-over'));
}

function onDragOver(e) {
    e.preventDefault();
    e.currentTarget.classList.add('drag-over');
}

function onDragLeave(e) {
    if (!e.currentTarget.contains(e.relatedTarget)) e.currentTarget.classList.remove('drag-over');
}

function onDrop(e, colName) {
    e.preventDefault();
    document.querySelectorAll('.column').forEach(c => c.classList.remove('drag-over'));
    const task = tasks.find(t => t.id === dragId);
    if (!task || task.col === colName) return;
    task.col = colName;
    saveTasks(); renderBoard();
    notify('Задача перемещена');
}

let notifTimer;
function notify(msg, isError = false) {
    const el = document.getElementById('notification');
    el.textContent = msg;
    el.className = 'highlight show' + (isError ? ' error' : '');
    clearTimeout(notifTimer);
    notifTimer = setTimeout(() => { el.className = 'highlight'; }, 2800);
}

loadTasks();
renderBoard();