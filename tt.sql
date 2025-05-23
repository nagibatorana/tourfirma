-- Создание базы данных
CREATE DATABASE turfirma;
\c turfirma

-- Таблица туров
CREATE TABLE tours (
    tour_id SERIAL PRIMARY KEY,
    tour_name VARCHAR(100) NOT NULL,
    description TEXT,
    duration_days INTEGER,
    difficulty_level VARCHAR(20)
);

-- Таблица туристов
CREATE TABLE tourists (
    tourist_id SERIAL PRIMARY KEY,
    tourist_surname VARCHAR(50) NOT NULL,
    tourist_name VARCHAR(50) NOT NULL,
    tourist_otch VARCHAR(50),
    passport VARCHAR(20) NOT NULL UNIQUE,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    registration_date DATE DEFAULT CURRENT_DATE
);

-- Таблица сезонов
CREATE TABLE seasons (
    season_id SERIAL PRIMARY KEY,
    tour_id INTEGER NOT NULL REFERENCES tours(tour_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    closed BOOLEAN DEFAULT FALSE,
    amount INTEGER NOT NULL CHECK (amount > 0),
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    CONSTRAINT valid_dates CHECK (end_date > start_date)
);

-- Таблица путевок
CREATE TABLE putevki (
    putevki_id SERIAL PRIMARY KEY,
    tourist_id INTEGER NOT NULL REFERENCES tourists(tourist_id) ON DELETE CASCADE,
    season_id INTEGER NOT NULL REFERENCES seasons(season_id) ON DELETE CASCADE,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    CONSTRAINT unique_tourist_season UNIQUE (tourist_id, season_id)
);

-- Таблица платежей
CREATE TABLE payment (
    payment_id SERIAL PRIMARY KEY,
    putevki_id INTEGER NOT NULL REFERENCES putevki(putevki_id) ON DELETE CASCADE,
    payment_date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    payment_method VARCHAR(20),
    notes TEXT
);

-- Индексы для улучшения производительности
CREATE INDEX idx_seasons_tour_id ON seasons(tour_id);
CREATE INDEX idx_putevki_tourist_id ON putevki(tourist_id);
CREATE INDEX idx_putevki_season_id ON putevki(season_id);
CREATE INDEX idx_payment_putevki_id ON payment(putevki_id);

-- Вставка тестовых данных (3 тура)
INSERT INTO tours (tour_name, description, duration_days, difficulty_level) VALUES
('Альпийские вершины', 'Тур по швейцарским Альпам с восхождением на Маттерхорн', 10, 'Сложный'),
('Итальянские каникулы', 'Экскурсионный тур по Риму, Флоренции и Венеции', 7, 'Легкий'),
('Скандинавское сафари', 'Путешествие по Норвегии с наблюдением за северным сиянием', 14, 'Средний');

-- Вставка тестовых данных (3 сезона)
INSERT INTO seasons (tour_id, start_date, end_date, closed, amount, price) VALUES
(1, '2024-06-15', '2024-06-25', FALSE, 15, 120000.00),
(2, '2024-07-01', '2024-07-08', FALSE, 20, 85000.00),
(3, '2024-12-10', '2024-12-24', FALSE, 10, 150000.00);

-- Вставка тестовых данных (3 туриста)
INSERT INTO tourists (tourist_surname, tourist_name, tourist_otch, passport, city, country, phone, email) VALUES
('Иванов', 'Иван', 'Иванович', '1234567890', 'Москва', 'Россия', '+79991234567', 'ivanov@example.com'),
('Петрова', 'Мария', 'Сергеевна', '0987654321', 'Санкт-Петербург', 'Россия', '+79992345678', 'petrova@example.com'),
('Сидоров', 'Алексей', 'Иванович', '1122334455', 'Новосибирск', 'Россия', '+79993456789', 'sidorov@example.com');

-- Вставка тестовых данных (путевки)
INSERT INTO putevki (tourist_id, season_id, price) VALUES
(1, 1, 120000.00),
(2, 2, 85000.00),
(3, 3, 150000.00);

-- Вставка тестовых данных (платежи)
INSERT INTO payment (putevki_id, payment_date, amount, payment_method) VALUES
(1, '2024-05-01', 60000.00, 'Карта'),
(1, '2024-05-15', 60000.00, 'Карта'),
(2, '2024-05-05', 85000.00, 'Наличные'),
(3, '2024-05-10', 150000.00, 'Перевод');