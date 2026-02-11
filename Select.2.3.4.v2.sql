-- ============================================
-- ЗАДАНИЕ 2
-- ============================================

-- Добавление тестовых треков для проверки поиска "мой"/"my"
-- (Эти данные добавляются для гарантии непустых результатов)
INSERT INTO tracks (title, duration, album_id) VALUES 
-- Должны попасть в выборку:
('my own', 180, 1),
('own my', 190, 1),
('my', 200, 1),
('oh my god', 210, 1),
('мой собственный', 220, 1),
('собственный мой', 230, 1),
('мой', 240, 1),
('о мой бог', 250, 1),

-- НЕ должны попасть в выборку:
('myself', 260, 1),
('by myself', 270, 1),
('bemy self', 280, 1),
('myself by', 290, 1),
('by myself by', 300, 1),
('beemy', 310, 1),
('premyne', 320, 1),
('memory', 330, 1),
('myth', 340, 1),
('mystery', 350, 1)
ON CONFLICT DO NOTHING;

-- 1. Название и продолжительность самого длительного трека
SELECT 
    title AS "Название трека",
    duration AS "Длительность (сек)",
    CONCAT(FLOOR(duration / 60), ':', LPAD((duration % 60)::TEXT, 2, '0')) AS "Длительность (мм:сс)"
FROM tracks
WHERE duration = (SELECT MAX(duration) FROM tracks);

-- 2. Название треков, продолжительность которых не менее 3,5 минут
SELECT 
    title AS "Название трека",
    duration AS "Длительность (сек)",
    CONCAT(FLOOR(duration / 60), ':', LPAD((duration % 60)::TEXT, 2, '0')) AS "Длительность (мм:сс)"
FROM tracks
WHERE duration >= 210
ORDER BY duration DESC;

-- 3. Названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT 
    title AS "Название сборника",
    release_year AS "Год выпуска"
FROM compilations
WHERE release_year BETWEEN 2018 AND 2020
ORDER BY release_year;

-- 4. Исполнители, чьё имя состоит из одного слова
SELECT 
    name AS "Исполнитель"
FROM artists
WHERE name NOT LIKE '% %' AND name NOT LIKE '%-%'
ORDER BY name;

-- 5. Название треков, которые содержат слово «мой» или «my»
-- Основной способ с ILIKE (8 проверок для поиска целых слов)
SELECT 
    title AS "Название трека",
    'Должен попасть в выборку' AS "Статус"
FROM tracks
WHERE 
    -- слово "мой" в разных позициях
    title ILIKE 'мой %' OR      -- в начале с пробелом
    title ILIKE '% мой' OR      -- в конце с пробелом
    title ILIKE '% мой %' OR    -- в середине с пробелами
    title ILIKE 'мой' OR        -- единственное слово
    
    -- слово "my" в разных позициях
    title ILIKE 'my %' OR       -- в начале с пробелом
    title ILIKE '% my' OR       -- в конце с пробелом
    title ILIKE '% my %' OR     -- в середине с пробелами
    title ILIKE 'my'            -- единственное слово

UNION ALL

-- Проверка: треки, которые НЕ должны попасть
SELECT 
    title AS "Название трека",
    'НЕ должен попасть в выборку' AS "Статус"
FROM tracks
WHERE title IN ('myself', 'by myself', 'bemy self', 'myself by', 'by myself by', 'beemy', 'premyne', 'memory', 'myth', 'mystery')
  AND title NOT IN (
    SELECT title FROM tracks WHERE 
    title ILIKE 'мой %' OR title ILIKE '% мой' OR title ILIKE '% мой %' OR title ILIKE 'мой' OR
    title ILIKE 'my %' OR title ILIKE '% my' OR title ILIKE '% my %' OR title ILIKE 'my'
  )

ORDER BY "Статус" DESC, "Название трека";

-- ============================================
-- ЗАДАНИЕ 3
-- ============================================

-- 1. Количество исполнителей в каждом жанре
SELECT 
    g.name AS "Жанр",
    COUNT(DISTINCT ag.artist_id) AS "Количество исполнителей"
FROM genres g
LEFT JOIN artists_genres ag ON g.id = ag.genre_id
GROUP BY g.id, g.name
ORDER BY COUNT(DISTINCT ag.artist_id) DESC;

-- 2. Количество треков, вошедших в альбомы 2019–2020 годов
SELECT 
    COUNT(t.id) AS "Количество треков"
FROM tracks t
JOIN albums a ON t.album_id = a.id
WHERE a.release_year BETWEEN 2019 AND 2020;

-- 3. Средняя продолжительность треков по каждому альбому
SELECT 
    a.title AS "Альбом",
    ROUND(AVG(t.duration), 1) AS "Средняя продолжительность (сек)"
FROM albums a
JOIN tracks t ON a.id = t.album_id
GROUP BY a.id, a.title
ORDER BY AVG(t.duration) DESC;

-- 4. Все исполнители, которые не выпустили альбомы в 2020 году
SELECT 
    a.name AS "Исполнитель"
FROM artists a
WHERE NOT EXISTS (
    SELECT 1 
    FROM artists_albums aa 
    JOIN albums al ON aa.album_id = al.id 
    WHERE aa.artist_id = a.id 
      AND al.release_year = 2020
)
ORDER BY a.name;

-- 5. Названия сборников, в которых присутствует конкретный исполнитель (выбран Taylor Swift)
SELECT DISTINCT 
    c.title AS "Название сборника"
FROM compilations c
JOIN compilation_tracks ct ON c.id = ct.compilation_id
JOIN tracks t ON ct.track_id = t.id
JOIN albums al ON t.album_id = al.id
JOIN artists_albums aa ON al.id = aa.album_id
JOIN artists a ON aa.artist_id = a.id
WHERE a.name = 'Taylor Swift'
ORDER BY c.title;

-- ============================================
-- ЗАДАНИЕ 4
-- ============================================

-- 1. Названия альбомов, в которых присутствуют исполнители более чем одного жанра
SELECT DISTINCT
    a.title AS "Название альбома"
FROM albums a
JOIN artists_albums aa ON a.id = aa.album_id
JOIN artists ar ON aa.artist_id = ar.id
JOIN (
    SELECT artist_id, COUNT(DISTINCT genre_id) AS genre_count
    FROM artists_genres
    GROUP BY artist_id
    HAVING COUNT(DISTINCT genre_id) > 1
) ag ON ar.id = ag.artist_id
ORDER BY a.title;

-- 2. Наименования треков, которые не входят в сборники
SELECT 
    t.title AS "Название трека"
FROM tracks t
LEFT JOIN compilation_tracks ct ON t.id = ct.track_id
WHERE ct.track_id IS NULL
ORDER BY t.title;

-- 3. Исполнитель или исполнители, написавшие самый короткий по продолжительности трек
SELECT DISTINCT 
    ar.name AS "Исполнитель"
FROM tracks t
JOIN albums a ON t.album_id = a.id
JOIN artists_albums aa ON a.id = aa.album_id
JOIN artists ar ON aa.artist_id = ar.id
WHERE t.duration = (SELECT MIN(duration) FROM tracks)
ORDER BY ar.name;

-- 4. Названия альбомов, содержащих наименьшее количество треков
WITH album_track_counts AS (
    SELECT 
        a.id,
        a.title,
        COUNT(t.id) AS track_count
    FROM albums a
    LEFT JOIN tracks t ON a.id = t.album_id
    GROUP BY a.id, a.title
)
SELECT 
    atc.title AS "Название альбома"
FROM album_track_counts atc
WHERE atc.track_count = (SELECT MIN(track_count) FROM album_track_counts)
ORDER BY atc.title;