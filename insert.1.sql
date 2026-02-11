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

-- 3. Альбомы (сначала альбомы, потом треки, т.к. треки ссылаются на альбомы)
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

-- 4. Треки (после альбомов)
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

-- 5. Сборники (можно после треков)
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

-- 6. Связи исполнителей и жанров (после жанров и исполнителей)
INSERT INTO artists_genres (artist_id, genre_id) VALUES 
(1, 1), (1, 2), (2, 2), (3, 3), (8, 3), (12, 3), 
(4, 4), (10, 4), (11, 4), (5, 1), (6, 5), (7, 2), (8, 2);

-- 7. Связи исполнителей и альбомов (после исполнителей и альбомов)
INSERT INTO artists_albums (artist_id, album_id) VALUES 
(1, 1), (2, 2), (5, 3), (7, 4), (8, 5), (3, 6), 
(9, 7), (12, 8), (3, 9), (4, 10), (11, 11), 
(10, 12), (4, 13), (6, 14), (13, 15);

-- 8. Связи сборников и треков (после сборников и треков)
INSERT INTO compilation_tracks (compilation_id, track_id) VALUES 
(1, 4), (1, 5), (1, 6), (1, 19),
(2, 7), (2, 8), (2, 9), (2, 13), (2, 14),
(3, 1), (3, 24), (3, 30), (3, 31),
(4, 15), (4, 16), (4, 18), (4, 19), (4, 20), 
(4, 21), (4, 22), (4, 23),
(5, 25), (5, 26), (5, 27), (5, 29),
(6, 5), (6, 15), (6, 19), (6, 25),
(7, 2), (7, 3), (7, 13), (7, 29),
(8, 4), (8, 6), (8, 24), (8, 25), (8, 29),
(9, 20), (9, 21),
(10, 7), (10, 9), (10, 10), (10, 11), (10, 13);