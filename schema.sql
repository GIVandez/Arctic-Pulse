-- 1. Таблица с источниками новостей
CREATE TABLE sources (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    rss_url TEXT NOT NULL,
    website_url TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    last_fetched TIMESTAMPTZ DEFAULT NOW(),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Таблица с новостями
CREATE TABLE news (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_id INT NOT NULL REFERENCES sources(id) ON DELETE RESTRICT,
    news_url TEXT NOT NULL,
    publication_date TIMESTAMPTZ NOT NULL,
    material_author TEXT NOT NULL,
    title TEXT NOT NULL,
    slug TEXT NOT NULL,
    content TEXT NOT NULL,
    content_clean TEXT NOT NULL,
    summary_ai TEXT,
    tokens_used INT,
    processing_time DECIMAL(10, 2),
    processed_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(), -- Исправлено: добавлен DEFAULT
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Таблица тегов
CREATE TABLE tags (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    color VARCHAR(7) DEFAULT '#3B82F6',
    is_active BOOLEAN DEFAULT TRUE,
    usage_count INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Связь новостей и тегов (Суррогатный PK добавлен для совместимости с Directus Many-to-Many)
CREATE TABLE news_tags (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    news_id INT NOT NULL REFERENCES news(id) ON DELETE CASCADE,
    tag_id INT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT uq_news_tag UNIQUE (news_id, tag_id)
);
