import csv
import json

header = ['Животное', 'Среда обитания']
animals_data = [
    ['Медведь', 'Лес'],
    ['Дельфин', 'Океан'],
    ['Верблюд', 'Пустыня']
]

with open('animals.csv', 'w', encoding='utf-8', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(header)
    writer.writerows(animals_data)

def convert_csv_to_json(csv_path: str, json_path: str) -> None:
    with open(csv_path, 'r', encoding='utf-8') as csv_file:
        reader = csv.DictReader(csv_file)
        data = list(reader)
    
    with open(json_path, 'w', encoding='utf-8') as json_file:
        json.dump(data, json_file, ensure_ascii=False, indent=4)

def convert_json_to_csv(json_path: str, csv_path: str) -> None:
    with open(json_path, 'r', encoding='utf-8') as json_file:
        data = json.load(json_file)
    
    if data:
        fieldnames = data[0].keys()
        with open(csv_path, 'w', encoding='utf-8', newline='') as csv_file:
            writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(data)
if __name__ == "__main__":
    convert_csv_to_json('animals.csv', 'animals.json')
    convert_json_to_csv('animals.json', 'animals_back.csv')
    print("Конвертация выполнена успешно!")

