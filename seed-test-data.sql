-- Test data for local Directus/PostgreSQL verification.

INSERT INTO sources (name, rss_url, website_url, is_active, notes)
SELECT 'Habr', 'https://habr.com/ru/rss/all/all/', 'https://habr.com', TRUE, 'Test source for Directus integration'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE name = 'Habr');

INSERT INTO sources (name, rss_url, website_url, is_active, notes)
SELECT 'TechCrunch', 'https://techcrunch.com/feed/', 'https://techcrunch.com', TRUE, 'Test source for Directus integration'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE name = 'TechCrunch');

INSERT INTO sources (name, rss_url, website_url, is_active, notes)
SELECT 'The Verge', 'https://www.theverge.com/rss/index.xml', 'https://www.theverge.com', TRUE, 'Test source for Directus integration'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE name = 'The Verge');

INSERT INTO tags (name, description, color, is_active)
VALUES
  ('AI', 'Artificial intelligence news', '#3B82F6', TRUE),
  ('Frontend', 'Frontend and UI topics', '#8B5CF6', TRUE),
  ('Backend', 'Backend and API topics', '#10B981', TRUE),
  ('DevOps', 'Infrastructure and deployment', '#F59E0B', TRUE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO news (
  source_id,
  news_url,
  publication_date,
  material_author,
  title,
  slug,
  content,
  content_clean,
  summary_ai,
  tokens_used,
  processing_time,
  processed_at
)
SELECT
  s.id,
  'https://habr.com/ru/articles/900001/',
  NOW() - INTERVAL '3 days',
  'Habr Editorial',
  'AI tools are changing news aggregation',
  'ai-tools-changing-news-aggregation',
  'Raw article text about AI and news aggregation.',
  'Clean article text about AI and news aggregation.',
  'AI tools improve article selection and summarization.',
  1200,
  1.45,
  NOW() - INTERVAL '3 days'
FROM sources s
WHERE s.name = 'Habr'
  AND NOT EXISTS (SELECT 1 FROM news WHERE slug = 'ai-tools-changing-news-aggregation');

INSERT INTO news (
  source_id,
  news_url,
  publication_date,
  material_author,
  title,
  slug,
  content,
  content_clean,
  summary_ai,
  tokens_used,
  processing_time,
  processed_at
)
SELECT
  s.id,
  'https://techcrunch.com/2026/06/01/frontend-tooling-update/',
  NOW() - INTERVAL '2 days',
  'TechCrunch Staff',
  'Frontend tooling gets faster for content-heavy apps',
  'frontend-tooling-gets-faster-for-content-heavy-apps',
  'Raw article text about frontend tooling.',
  'Clean article text about frontend tooling.',
  'Modern frontend tooling reduces content delivery latency.',
  980,
  1.08,
  NOW() - INTERVAL '2 days'
FROM sources s
WHERE s.name = 'TechCrunch'
  AND NOT EXISTS (SELECT 1 FROM news WHERE slug = 'frontend-tooling-gets-faster-for-content-heavy-apps');

INSERT INTO news (
  source_id,
  news_url,
  publication_date,
  material_author,
  title,
  slug,
  content,
  content_clean,
  summary_ai,
  tokens_used,
  processing_time,
  processed_at
)
SELECT
  s.id,
  'https://www.theverge.com/2026/06/02/devops-observability-improves/',
  NOW() - INTERVAL '1 day',
  'The Verge Team',
  'DevOps observability improves incident response',
  'devops-observability-improves-incident-response',
  'Raw article text about observability.',
  'Clean article text about observability.',
  'Better observability shortens incident response time.',
  1040,
  1.22,
  NOW() - INTERVAL '1 day'
FROM sources s
WHERE s.name = 'The Verge'
  AND NOT EXISTS (SELECT 1 FROM news WHERE slug = 'devops-observability-improves-incident-response');

INSERT INTO news_tags (news_id, tag_id)
SELECT n.id, t.id
FROM news n
JOIN tags t ON t.name = 'AI'
WHERE n.slug = 'ai-tools-changing-news-aggregation'
  AND NOT EXISTS (
    SELECT 1 FROM news_tags nt WHERE nt.news_id = n.id AND nt.tag_id = t.id
  );

INSERT INTO news_tags (news_id, tag_id)
SELECT n.id, t.id
FROM news n
JOIN tags t ON t.name = 'Frontend'
WHERE n.slug = 'frontend-tooling-gets-faster-for-content-heavy-apps'
  AND NOT EXISTS (
    SELECT 1 FROM news_tags nt WHERE nt.news_id = n.id AND nt.tag_id = t.id
  );

INSERT INTO news_tags (news_id, tag_id)
SELECT n.id, t.id
FROM news n
JOIN tags t ON t.name = 'Backend'
WHERE n.slug = 'frontend-tooling-gets-faster-for-content-heavy-apps'
  AND NOT EXISTS (
    SELECT 1 FROM news_tags nt WHERE nt.news_id = n.id AND nt.tag_id = t.id
  );

INSERT INTO news_tags (news_id, tag_id)
SELECT n.id, t.id
FROM news n
JOIN tags t ON t.name = 'DevOps'
WHERE n.slug = 'devops-observability-improves-incident-response'
  AND NOT EXISTS (
    SELECT 1 FROM news_tags nt WHERE nt.news_id = n.id AND nt.tag_id = t.id
  );