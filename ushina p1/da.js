const users = [
  { id: 1, name: "Anna", age: 22, city: "Moscow", isActive: true },
  { id: 2, name: "Oleg", age: 17, city: "Kazan", isActive: false },
  { id: 3, name: "Ivan", age: 30, city: "Moscow", isActive: true },
  { id: 4, name: "Maria", age: 25, city: "Sochi", isActive: false }
];


//1 задание
function getActiveUsers(users) {
  return users.filter(user => user.isActive);
}

console.log(getActiveUsers(users));

//2 задание

const getUserNames = (users) => {
  return users.map(user => user.name);
};
console.log(getUserNames(users)); 

//3 задание

function findUserById(users, id){
  const user = users.find(user => user.id === id);
  return user || null;
};

console.log(findUserById(users, 2));

// 4 задание

function getUsersStatistics (users) {
  const total = users.length;
  const active = users.filter(user => user.isActive).length;
  const inactive = total - active;

  return {
    total,
    active,
    inactive
  };
};

console.log(getUsersStatistics(users));

// 5 задание 

function getAverageAge (users) {
  if (users.length === 0) return 0;
  const sum = users.reduce((acc, user) => acc + user.age, 0);
  return sum / users.length;
};

console.log(getAverageAge(users));

//6 задание 

function groupUsersByCity (users) {
  return users.reduce((acc, user) => {
    const city = user.city;

    if (!acc[city]) {
      acc[city] = [];
    }
    acc[city].push(user);

    return acc;
  }, {});
};

console.log(groupUsersByCity(users));