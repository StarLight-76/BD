import psycopg2
from psycopg2.extras import RealDictCursor
from typing import List, Dict, Any, Optional
import sys


class CustomerDB:
    """Класс для управления базой данных клиентов в PostgreSQL"""

    def __init__(self, dbname: str = 'clients_db', user: str = 'postgres',
                 password: str = None, host: str = 'localhost', port: str = '5432'):
        """Параметры подключения к PostgreSQL"""
        self.params = {
            'dbname': dbname,
            'user': user,
            'password': password,
            'host': host,
            'port': port
        }
        self.conn = None
        self.cursor = None

    def connect(self):
        """Установка соединения с БД"""
        try:
            self.conn = psycopg2.connect(**self.params)
            self.cursor = self.conn.cursor(cursor_factory=RealDictCursor)
            return True
        except Exception as e:
            print(f"Ошибка подключения: {e}")
            return False

    def disconnect(self):
        """Закрытие соединения с БД"""
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()

    def commit(self):
        """Подтверждение транзакции"""
        if self.conn:
            self.conn.commit()

    def rollback(self):
        """Откат транзакции"""
        if self.conn:
            self.conn.rollback()

    def create_db(self):
        """Функция 1: Создание структуры БД (таблицы)"""

        # Подключаемся к стандартной базе postgres для создания нашей БД
        try:
            temp_params = self.params.copy()
            temp_params['dbname'] = 'postgres'
            conn = psycopg2.connect(**temp_params)
            conn.autocommit = True
            cur = conn.cursor()

            # Проверяем, существует ли база данных
            cur.execute(f"SELECT 1 FROM pg_database WHERE datname = '{self.params['dbname']}'")
            exists = cur.fetchone()

            if not exists:
                cur.execute(f'CREATE DATABASE {self.params["dbname"]}')
                print(f"База данных {self.params['dbname']} создана")

            cur.close()
            conn.close()

        except Exception as e:
            print(f"Ошибка при создании БД: {e}")
            return False

        # Подключаемся к нашей БД и создаем таблицы
        if not self.connect():
            return False

        try:
            # Создание таблицы клиентов
            self.cursor.execute('''
                CREATE TABLE IF NOT EXISTS customers (
                    id SERIAL PRIMARY KEY,
                    first_name VARCHAR(50) NOT NULL,
                    last_name VARCHAR(50) NOT NULL,
                    email VARCHAR(100) UNIQUE NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            ''')

            # Создание таблицы телефонов
            self.cursor.execute('''
                CREATE TABLE IF NOT EXISTS phones (
                    id SERIAL PRIMARY KEY,
                    customer_id INTEGER NOT NULL,
                    phone_number VARCHAR(20) NOT NULL,
                    FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
                )
            ''')

            # Индекс для быстрого поиска
            self.cursor.execute('''
                CREATE INDEX IF NOT EXISTS idx_phone_number ON phones (phone_number)
            ''')

            self.commit()
            print("Таблицы customers и phones успешно созданы")
            return True

        except Exception as e:
            self.rollback()
            print(f"Ошибка при создании таблиц: {e}")
            return False
        finally:
            self.disconnect()

    def add_client(self, first_name: str, last_name: str, email: str, phones: List[str] = None) -> int:
        """Функция 2: Добавление нового клиента"""

        if not self.connect():
            return -1

        try:
            self.cursor.execute('''
                INSERT INTO customers (first_name, last_name, email)
                VALUES (%s, %s, %s)
                RETURNING id
            ''', (first_name, last_name, email))

            result = self.cursor.fetchone()
            client_id = result['id']

            if phones:
                for phone in phones:
                    self.cursor.execute('''
                        INSERT INTO phones (customer_id, phone_number)
                        VALUES (%s, %s)
                    ''', (client_id, phone))

            self.commit()
            print(f"Клиент {first_name} {last_name} добавлен с ID {client_id}")
            return client_id

        except psycopg2.IntegrityError:
            self.rollback()
            print(f"Ошибка: Клиент с email {email} уже существует")
            return -1
        except Exception as e:
            self.rollback()
            print(f"Ошибка при добавлении клиента: {e}")
            return -1
        finally:
            self.disconnect()

    def add_phone(self, client_id: int, phone: str) -> bool:
        """Функция 3: Добавление телефона для существующего клиента"""

        if not self.connect():
            return False

        try:
            self.cursor.execute('SELECT id FROM customers WHERE id = %s', (client_id,))
            if not self.cursor.fetchone():
                print(f"Ошибка: Клиент с ID {client_id} не найден")
                return False

            self.cursor.execute('''
                INSERT INTO phones (customer_id, phone_number)
                VALUES (%s, %s)
            ''', (client_id, phone))

            self.commit()
            print(f"Телефон {phone} добавлен клиенту ID {client_id}")
            return True

        except Exception as e:
            self.rollback()
            print(f"Ошибка при добавлении телефона: {e}")
            return False
        finally:
            self.disconnect()

    def change_client(self, client_id: int, first_name: str = None,
                      last_name: str = None, email: str = None, phones: List[str] = None) -> bool:
        """Функция 4: Изменение данных о клиенте"""

        if not self.connect():
            return False

        try:
            self.cursor.execute('''
                SELECT first_name, last_name, email FROM customers WHERE id = %s
            ''', (client_id,))

            customer = self.cursor.fetchone()
            if not customer:
                print(f"Ошибка: Клиент с ID {client_id} не найден")
                return False

            new_first_name = first_name if first_name is not None else customer['first_name']
            new_last_name = last_name if last_name is not None else customer['last_name']
            new_email = email if email is not None else customer['email']

            self.cursor.execute('''
                UPDATE customers 
                SET first_name = %s, last_name = %s, email = %s
                WHERE id = %s
            ''', (new_first_name, new_last_name, new_email, client_id))

            if phones is not None:
                self.cursor.execute('DELETE FROM phones WHERE customer_id = %s', (client_id,))
                if phones:
                    for phone in phones:
                        self.cursor.execute('''
                            INSERT INTO phones (customer_id, phone_number)
                            VALUES (%s, %s)
                        ''', (client_id, phone))

            self.commit()
            print(f"Данные клиента ID {client_id} обновлены")
            return True

        except psycopg2.IntegrityError:
            self.rollback()
            print(f"Ошибка: Клиент с email {email} уже существует")
            return False
        except Exception as e:
            self.rollback()
            print(f"Ошибка при обновлении клиента: {e}")
            return False
        finally:
            self.disconnect()

    def delete_phone(self, client_id: int = None, phone: str = None, phone_id: int = None) -> bool:
        """Функция 5: Удаление телефона для существующего клиента"""

        if not self.connect():
            return False

        try:
            if phone_id is not None:
                self.cursor.execute('DELETE FROM phones WHERE id = %s', (phone_id,))
            elif phone is not None and client_id is not None:
                self.cursor.execute('''
                    DELETE FROM phones 
                    WHERE customer_id = %s AND phone_number = %s
                ''', (client_id, phone))
            elif phone is not None:
                self.cursor.execute('DELETE FROM phones WHERE phone_number = %s', (phone,))
            else:
                print("Ошибка: Не указаны параметры для удаления телефона")
                return False

            self.commit()

            if self.cursor.rowcount > 0:
                print("Телефон успешно удален")
                return True
            else:
                print("Ошибка: Телефон не найден")
                return False

        except Exception as e:
            self.rollback()
            print(f"Ошибка при удалении телефона: {e}")
            return False
        finally:
            self.disconnect()

    def delete_client(self, client_id: int) -> bool:
        """Функция 6: Удаление существующего клиента"""

        if not self.connect():
            return False

        try:
            self.cursor.execute('SELECT id FROM customers WHERE id = %s', (client_id,))
            if not self.cursor.fetchone():
                print(f"Ошибка: Клиент с ID {client_id} не найден")
                return False

            self.cursor.execute('DELETE FROM customers WHERE id = %s', (client_id,))

            self.commit()
            print(f"Клиент ID {client_id} удален")
            return True

        except Exception as e:
            self.rollback()
            print(f"Ошибка при удалении клиента: {e}")
            return False
        finally:
            self.disconnect()

    def find_client(self, first_name: str = None, last_name: str = None,
                    email: str = None, phone: str = None) -> List[Dict[str, Any]]:
        """Функция 7: Поиск клиента по его данным"""

        if not self.connect():
            return []

        try:
            # Простой запрос без JSON агрегации
            query = '''
                SELECT DISTINCT c.id, c.first_name, c.last_name, c.email
                FROM customers c
                WHERE 1=1
            '''
            params = []

            if first_name:
                query += ' AND c.first_name ILIKE %s'
                params.append(f'%{first_name}%')

            if last_name:
                query += ' AND c.last_name ILIKE %s'
                params.append(f'%{last_name}%')

            if email:
                query += ' AND c.email ILIKE %s'
                params.append(f'%{email}%')

            if phone:
                query += ''' AND c.id IN (
                    SELECT customer_id FROM phones 
                    WHERE phone_number ILIKE %s
                )'''
                params.append(f'%{phone}%')

            query += ' ORDER BY c.id'

            self.cursor.execute(query, params)
            clients = self.cursor.fetchall()

            # Для каждого клиента получаем его телефоны отдельным запросом
            for client in clients:
                self.cursor.execute('''
                    SELECT id, phone_number FROM phones 
                    WHERE customer_id = %s
                    ORDER BY id
                ''', (client['id'],))
                phones_result = self.cursor.fetchall()
                client['phones'] = phones_result if phones_result else []

            return clients

        except Exception as e:
            print(f"Ошибка при поиске: {e}")
            return []
        finally:
            self.disconnect()

    def get_all_clients(self) -> List[Dict[str, Any]]:
        """Вспомогательная функция для получения всех клиентов"""
        return self.find_client()


def main():
    """Демонстрация работы всех функций"""

    print("Тестирование программы управления клиентами (PostgreSQL)")
    print("-" * 50)

    # Вводим пароль
    password = input("Введите пароль для PostgreSQL (по умолчанию 'postgres'): ")
    if not password:
        password = 'postgres'

    # Создаем экземпляр класса
    db = CustomerDB(
        dbname='clients_test_db',
        user='postgres',
        password=password,
        host='localhost',
        port='5432'
    )

    # 1. Создаем структуру БД
    print("\n1. Создание структуры БД")
    if not db.create_db():
        print("Не удалось создать БД. Проверьте:")
        print("- Запущен ли PostgreSQL (services.msc)")
        print("- Правильность пароля")
        return

    # 2. Добавляем клиентов
    print("\n2. Добавление клиентов")
    client1 = db.add_client("Иван", "Иванов", "ivan@example.com", ["+79991234567", "+79997654321"])
    client2 = db.add_client("Петр", "Петров", "petr@example.com")
    client3 = db.add_client("Сергей", "Сергеев", "sergey@example.com", ["+79995555555"])

    # 3. Добавляем телефон существующему клиенту
    print("\n3. Добавление телефона клиенту")
    if client2 != -1:
        db.add_phone(client2, "+79991112233")

    # 4. Изменяем данные клиента
    print("\n4. Изменение данных клиента")
    if client1 != -1:
        db.change_client(client1, first_name="Иоанн", email="ioann@example.com")

    # 5. Удаляем телефон
    print("\n5. Удаление телефона")
    db.delete_phone(phone="+79991234567")

    # 6. Ищем клиентов
    print("\n6. Поиск клиентов")

    print("\nПоиск по имени 'Иоанн':")
    found = db.find_client(first_name="Иоанн")
    for client in found:
        phones = [p['phone_number'] for p in client['phones']] if client['phones'] else []
        print(
            f"ID: {client['id']}, {client['first_name']} {client['last_name']}, Email: {client['email']}, Телефоны: {phones}")

    print("\nПоиск по телефону '+79995555555':")
    found = db.find_client(phone="+79995555555")
    for client in found:
        phones = [p['phone_number'] for p in client['phones']] if client['phones'] else []
        print(
            f"ID: {client['id']}, {client['first_name']} {client['last_name']}, Email: {client['email']}, Телефоны: {phones}")

    # 7. Удаляем клиента
    print("\n7. Удаление клиента")
    if client3 != -1:
        db.delete_client(client3)

    # 8. Показываем всех оставшихся клиентов
    print("\n8. Все клиенты после операций:")
    all_clients = db.get_all_clients()
    for client in all_clients:
        phones = [p['phone_number'] for p in client['phones']] if client['phones'] else []
        print(
            f"ID: {client['id']}, {client['first_name']} {client['last_name']}, Email: {client['email']}, Телефоны: {phones}")

    print("\n" + "-" * 50)
    print("Тестирование завершено")


if __name__ == "__main__":
    main()