-- ВСТАВКА ДАННЫХ

-- 1. Жанры
INSERT INTO genres (name) VALUES 
('Rock'),
('Pop'),
('Classical'), 
('Metal'),     
('Electronic'),
('Alternative'),
('Folk');

-- 2. Исполнители
INSERT INTO artists (name) VALUES 
('The Beatles'),
('Michael Jackson'),
('Pyotr Tchaikovsky'), 
('Metallica'),        
('Queen'),
('Daft Punk'),
('Taylor Swift'),
('Adele'),
('Ludwig van Beethoven'),
('Aria'),              
('Iron Maiden'),          
('Johann Sebastian Bach');

-- 3. Альбомы
INSERT INTO albums (title, release_year) VALUES 
('Abbey Road', 1969),
('Thriller', 1982),
('A Night at the Opera', 1975),
('1989', 2014),
('21', 2011),
('Swan Lake', 1877),         
('Symphony No. 5', 1808),    
('The Four Seasons', 1725),  
('The Nutcracker', 1892),    
('Master of Puppets', 1986),
('The Number of the Beast', 1982),     
('Hero of Asphalt', 1987),             
('...And Justice for All', 1988),      
('Random Access Memories', 2013),
('The Dark Side of the Moon', 1973);

-- 4. Треки
INSERT INTO tracks (title, duration, album_id) VALUES 
('Come Together', 259, 1),
('Something', 182, 1),
('Here Comes the Sun', 185, 1),
('Billie Jean', 294, 2),
('Beat It', 258, 2),
('Thriller', 357, 2),
('Scene', 223, 6),                     
('Waltz', 187, 6),                     
('Allegro con brio', 452, 7),          
('Andante con moto', 567, 7),          
('Spring: Allegro', 199, 8),           
('Summer: Presto', 178, 8),            
('Dance of the Sugar Plum Fairy', 132, 9),
('Waltz of the Flowers', 421, 9),
('Battery', 312, 10),
('Master of Puppets', 515, 10),
('Welcome Home (Sanitarium)', 387, 10),
('The Number of the Beast', 294, 11),
('Run to the Hills', 231, 11),
('Hero of Asphalt', 327, 12),
('Rose Street', 301, 12),
('One', 446, 13),
('Blackened', 403, 13),
('Bohemian Rhapsody', 354, 3),
('Shake It Off', 219, 4),
('Blank Space', 231, 4),
('Rolling in the Deep', 228, 5),
('Someone Like You', 285, 5),
('Get Lucky', 369, 14),
('Money', 382, 15),
('Time', 413, 15);

-- 5. Сборники
INSERT INTO compilations (title, release_year) VALUES 
('Greatest Hits of the 80s', 1990),
('Best of Classical Music', 2005),      
('Rock Classics', 2008),
('Heavy Metal Collection', 2010),       
('Summer Hits 2010s', 2020),
('Workout Mix', 2021),
('Chillout Lounge', 2018),
('Party Anthems', 2015),
('Russian Rock Hits', 2003),            
('Symphony Masterpieces', 2012);

-- 6. Связи исполнителей и жанров
-- Исправлены ID: теперь все ссылаются на существующих исполнителей (1-12)
INSERT INTO artists_genres (artist_id, genre_id) VALUES 
-- The Beatles (id=1) - Rock, Pop
(1, 1), (1, 2), 
-- Michael Jackson (id=2) - Pop
(2, 2), 
-- Pyotr Tchaikovsky (id=3) - Classical
(3, 3), 
-- Metallica (id=4) - Metal
(4, 4), 
-- Queen (id=5) - Rock
(5, 1), 
-- Daft Punk (id=6) - Electronic
(6, 5), 
-- Taylor Swift (id=7) - Pop
(7, 2), 
-- Adele (id=8) - Pop
(8, 2), 
-- Ludwig van Beethoven (id=9) - Classical
(9, 3), 
-- Aria (id=10) - Metal
(10, 4), 
-- Iron Maiden (id=11) - Metal
(11, 4), 
-- Johann Sebastian Bach (id=12) - Classical
(12, 3);

-- 7. Связи исполнителей и альбомов
INSERT INTO artists_albums (artist_id, album_id) VALUES 
-- The Beatles -> Abbey Road
(1, 1), 
-- Michael Jackson -> Thriller
(2, 2), 
-- Queen -> A Night at the Opera
(5, 3), 
-- Taylor Swift -> 1989
(7, 4), 
-- Adele -> 21
(8, 5), 
-- Pyotr Tchaikovsky -> Swan Lake
(3, 6), 
-- Ludwig van Beethoven -> Symphony No. 5
(9, 7), 
-- Johann Sebastian Bach -> The Four Seasons
(12, 8), 
-- Pyotr Tchaikovsky -> The Nutcracker
(3, 9), 
-- Metallica -> Master of Puppets
(4, 10), 
-- Iron Maiden -> The Number of the Beast
(11, 11), 
-- Aria -> Hero of Asphalt
(10, 12), 
-- Metallica -> ...And Justice for All
(4, 13), 
-- Daft Punk -> Random Access Memories
(6, 14), 
-- Pink Floyd -> The Dark Side of the Moon
(5, 15);

-- 8. Связи сборников и треков
-- Исправлены номера треков 
INSERT INTO compilation_tracks (compilation_id, track_id) VALUES 
-- Greatest Hits of the 80s (id=1)
(1, 4), -- Billie Jean (id=4)
(1, 5), -- Beat It (id=5)
(1, 6), -- Thriller (id=6)
-- Best of Classical Music (id=2)
(2, 7), -- Scene (id=7)
(2, 8), -- Waltz (id=8)
(2, 9), -- Allegro con brio (id=9)
(2, 13), -- Dance of the Sugar Plum Fairy (id=13)
(2, 14), -- Waltz of the Flowers (id=14)
-- Rock Classics (id=3)
(3, 1), -- Come Together (id=1)
(3, 24), -- Bohemian Rhapsody (id=24)
(3, 30), -- Money (id=30)
(3, 31), -- Time (id=31)
-- Heavy Metal Collection (id=4)
(4, 15), -- Battery (id=15)
(4, 16), -- Master of Puppets (id=16)
(4, 17), -- Welcome Home (Sanitarium) (id=17)
(4, 18), -- The Number of the Beast (id=18)
(4, 19), -- Run to the Hills (id=19)
(4, 20), -- Hero of Asphalt (id=20)
(4, 21), -- Rose Street (id=21)
(4, 22), -- One (id=22)
-- Summer Hits 2010s (id=5)
(5, 25), -- Shake It Off (id=25)
(5, 26), -- Blank Space (id=26)
(5, 27), -- Rolling in the Deep (id=27)
(5, 29), -- Get Lucky (id=29)
-- Workout Mix (id=6)
(6, 5), -- Beat It (id=5)
(6, 15), -- Battery (id=15)
(6, 19), -- Run to the Hills (id=19)
(6, 25), -- Shake It Off (id=25)
-- Chillout Lounge (id=7)
(7, 2), -- Something (id=2)
(7, 3), -- Here Comes the Sun (id=3)
(7, 13), -- Dance of the Sugar Plum Fairy (id=13)
(7, 29), -- Get Lucky (id=29)
-- Party Anthems (id=8)
(8, 4), -- Billie Jean (id=4)
(8, 6), -- Thriller (id=6)
(8, 24), -- Bohemian Rhapsody (id=24)
(8, 25), -- Shake It Off (id=25)
(8, 29), -- Get Lucky (id=29)
-- Russian Rock Hits (id=9)
(9, 20), -- Hero of Asphalt (id=20)
(9, 21), -- Rose Street (id=21)
-- Symphony Masterpieces (id=10)
(10, 7), -- Scene (id=7)
(10, 9), -- Allegro con brio (id=9)
(10, 10), -- Andante con moto (id=10)
(10, 11), -- Spring: Allegro (id=11)
(10, 13); -- Dance of the Sugar Plum Fairy (id=13)