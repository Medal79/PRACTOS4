let expenses = [];

function addExpense(expenses, title, amount, category) {
    if (!title || typeof title !== 'string' || title.trim() === '') {
        console.error('Ошибка: Название расхода не может быть пустым');
        return expenses;
    }
    if (typeof amount !== 'number' || amount <= 0 || isNaN(amount)) {
        console.error('Ошибка: Сумма должна быть положительным числом');
        return expenses;
    }
    if (!category || typeof category !== 'string' || category.trim() === '') {
        console.error('Ошибка: Категория не может быть пустой');
        return expenses;
    }

    const expense = {
        id: expenses.length + 1,
        title: title.trim(),
        amount: amount,
        category: category.trim()
    };
    expenses.push(expense);
    console.log('Добавлено: ' + title + ' (' + category + ') - ' + amount + 'руб');
    return expenses;
}

function printAllExpenses(expenses) {
    console.log("\nВСЕ РАСХОДЫ:");
    if (expenses.length === 0) {
        console.log("Нет расходов");
        return;
    }
    for (let i = 0; i < expenses.length; i++) {
        const exp = expenses[i];
        console.log(`${exp.id}. ${exp.title} (${exp.category}) - ${exp.amount}руб`);
    }
}

function getTotalAmount(expenses) {
    let total = 0;
    for (let i = 0; i < expenses.length; i++) {
        total += expenses[i].amount;
    }
    console.log(`\nОбщая сумма расходов: ${total}руб`);
    return total;
}

function getExpensesByCategory(expenses, category) {
    console.log('\nРАСХОДЫ ПО КАТЕГОРИИ "' + category + '":');
    let found = false;
    let categoryTotal = 0;
    
    for (let i = 0; i < expenses.length; i++) {
        if (expenses[i].category === category) {
            console.log(expenses[i].title + ' - ' + expenses[i].amount + 'руб');
            categoryTotal += expenses[i].amount;
            found = true;
        }
    }
    if (!found) {
        console.log('Расходов в этой категории нет');
    } else {
        console.log('Итого по категории "' + category + '": ' + categoryTotal + 'руб');
    }
    
    return expenses.filter(function(exp) {
        return exp.category === category;
    });
}

function findExpenseByTitle(expenses, title) {
    console.log(`\nПОИСК: "${title}"`);
    for (let i = 0; i < expenses.length; i++) {
        if (expenses[i].title === title) {
            console.log(`Найдено: ${expenses[i].title} (${expenses[i].category}) - ${expenses[i].amount}руб`);
            return expenses[i];
        }
    }
    console.log("Расход не найден");
    return null;
}

function deleteExpenseById(expenses, id) {
    for (let i = 0; i < expenses.length; i++) {
        if (expenses[i].id === id) {
            console.log(`Удален расход: ${expenses[i].title}`);
            expenses.splice(i, 1);
            return expenses;
        }
    }
    console.log(`Расход с ID ${id} не найден`);
    return expenses;
}

function printCategoryStats(expenses) {
    console.log("\nСТАТИСТИКА ПО КАТЕГОРИЯМ:");
    
    let cats = [];
    for (let i = 0; i < expenses.length; i++) {
        let category = expenses[i].category;
        let found = false;
        
        for (let j = 0; j < cats.length; j++) {
            if (cats[j] === category) {
                found = true;
                break;
            }
        }
        
        if (!found) {
            cats.push(category);
        }
    }
    
    for (let i = 0; i < cats.length; i++) {
        let cat = cats[i];
        let total = 0;
        let count = 0;
        
        for (let j = 0; j < expenses.length; j++) {
            if (expenses[j].category === cat) {
                total += expenses[j].amount;
                count++;
            }
        }
        
        console.log(cat + ": " + count + " операций, " + total + "руб");
    }
    
    if (cats.length === 0) {
        console.log("Нет данных");
    }
}

function createNavigator() {
    let currentIndex = 0;
    
    return {
        nextExpense: function(expenses) {
            if (expenses.length === 0) {
                console.log("Нет расходов для навигации");
                return null;
            }
            currentIndex = (currentIndex + 1) % expenses.length;
            const exp = expenses[currentIndex];
            console.log(`Текущий расход: ${exp.title} (${exp.category}) - ${exp.amount}руб`);
            return exp;
        }
    };
}

const navigator = createNavigator();

const expenseTracker = {
    expenses: expenses,
    
    addExpense: function(title, amount, category) {
        return addExpense(expenses, title, amount, category);
    },
    
    printAllExpenses: function() {
        return printAllExpenses(expenses);
    },
    
    getTotalAmount: function() {
        return getTotalAmount(expenses);
    },
    
    getExpensesByCategory: function(category) {
        return getExpensesByCategory(expenses, category);
    },
    
    findExpenseByTitle: function(title) {
        return findExpenseByTitle(expenses, title);
    },
    
    deleteExpenseById: function(id) {
        return deleteExpenseById(expenses, id);
    },
    
    printCategoryStats: function() {
        return printCategoryStats(expenses);
    },
    
    navigate: function() {
        return navigator.nextExpense(expenses);
    }
};

console.log("ТРЕКЕР РАСХОДОВ\n");

expenseTracker.addExpense("Detroid", 1500, "Игры");
expenseTracker.addExpense("God of war", 1100, "Игры");
expenseTracker.addExpense("Суши", 2400, "Еда");
expenseTracker.addExpense("PSP", 6000, "Развлечения");

expenseTracker.printAllExpenses();

expenseTracker.getTotalAmount();

expenseTracker.getExpensesByCategory("Игры");

expenseTracker.findExpenseByTitle("Detroid");

expenseTracker.navigate();
expenseTracker.navigate();

expenseTracker.printCategoryStats();

console.log("\nУДАЛЕНИЕ");
expenseTracker.deleteExpenseById(2);

expenseTracker.printAllExpenses();
expenseTracker.getTotalAmount();