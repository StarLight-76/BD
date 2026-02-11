-- Создание таблицы жанров
CREATE TABLE IF NOT EXISTS genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Создание таблицы исполнителей
CREATE TABLE IF NOT EXISTS artists (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Создание таблицы альбомов
CREATE TABLE IF NOT EXISTS albums (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    release_year INTEGER CHECK (release_year > 1900 AND release_year <= EXTRACT(YEAR FROM CURRENT_DATE))
);

-- Создание таблицы треков
CREATE TABLE IF NOT EXISTS tracks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    duration INTEGER NOT NULL CHECK (duration > 0),
    album_id INTEGER NOT NULL,
    FOREIGN KEY (album_id) REFERENCES albums(id) ON DELETE CASCADE
);

-- Создание таблицы сборников
CREATE TABLE IF NOT EXISTS compilations (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    release_year INTEGER CHECK (release_year > 1900 AND release_year <= EXTRACT(YEAR FROM CURRENT_DATE))
);

-- Создание таблицы связи исполнителей и жанров (многие-ко-многим)
CREATE TABLE IF NOT EXISTS artists_genres (
    id SERIAL PRIMARY KEY,
    artist_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES artists(id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(id) ON DELETE CASCADE,
    UNIQUE (artist_id, genre_id)
);

-- Создание таблицы связи исполнителей и альбомов (многие-ко-многим)
CREATE TABLE IF NOT EXISTS artists_albums (
    id SERIAL PRIMARY KEY,
    artist_id INTEGER NOT NULL,
    album_id INTEGER NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES artists(id) ON DELETE CASCADE,
    FOREIGN KEY (album_id) REFERENCES albums(id) ON DELETE CASCADE,
    UNIQUE (artist_id, album_id)
);

-- Создание таблицы связи сборников и треков (многие-ко-многим)
CREATE TABLE IF NOT EXISTS compilation_tracks (
    id SERIAL PRIMARY KEY,
    compilation_id INTEGER NOT NULL,
    track_id INTEGER NOT NULL,
    FOREIGN KEY (compilation_id) REFERENCES compilations(id) ON DELETE CASCADE,
    FOREIGN KEY (track_id) REFERENCES tracks(id) ON DELETE CASCADE,
    UNIQUE (compilation_id, track_id)
);

-- Создание индексов для улучшения производительности
CREATE INDEX idx_tracks_album_id ON tracks(album_id);
CREATE INDEX idx_artists_genres_artist_id ON artists_genres(artist_id);
CREATE INDEX idx_artists_genres_genre_id ON artists_genres(genre_id);
CREATE INDEX idx_artists_albums_artist_id ON artists_albums(artist_id);
CREATE INDEX idx_artists_albums_album_id ON artists_albums(album_id);
CREATE INDEX idx_compilation_tracks_compilation_id ON compilation_tracks(compilation_id);
CREATE INDEX idx_compilation_tracks_track_id ON compilation_tracks(track_id);