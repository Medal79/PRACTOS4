import requests

API_KEY = "5aa756a1ce2847d6af20e55930f984d1"

def get_weather(city: str, api_key: str):
    url = "https://api.openweathermap.org/data/2.5/weather"
    params = {
        'q': city,
        'appid': api_key,
        'units': 'metric',
        'lang': 'ru'
    }

    try:
        response = requests.get(url, params=params, timeout=5)

        if response.status_code == 401:
            print("Ошибка 401: Неверный API ключ")
            return None

        if response.status_code == 404:
            print(f"Ошибка 404: Город '{city}' не найден")
            return None

        response.raise_for_status()
        data = response.json()

        return {
            'city': data['name'],
            'temperature': round(data['main']['temp'], 1),
            'description': data['weather'][0]['description'],
            'humidity': data['main']['humidity'],
            'wind': data['wind']['speed']
        }

    except requests.exceptions.Timeout:
        print("Таймаут: сервер не ответил за 5 секунд")
        return None
    except requests.exceptions.ConnectionError:
        print("Ошибка соединения: проверьте интернет")
        return None
    except requests.exceptions.RequestException as e:
        print(f"Ошибка запроса: {e}")
        return None

city = input("Введите город: ")
weather = get_weather(city, API_KEY)

if weather:
    print(f"Город: {weather['city']}")
    print(f"Температура: {weather['temperature']} C")
    print(f"Описание: {weather['description'].capitalize()}")
    print(f"Влажность: {weather['humidity']}%")
    print(f"Ветер: {weather['wind']} м/с")
else:
    print("Не удалось получить данные о погоде")