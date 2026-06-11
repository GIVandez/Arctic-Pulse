# Для запуска n8n, directus, postgres:
> docker compose up -d

# n8n
> http://localhost:5678/

# directus
> http://localhost:8055/



# запрос для авторизации в Directus:
curl -s -X POST http://localhost:8055/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"<ЛОГИН ДИРЕКТУС>","password":"<ПАРОЛЬ ДИРЕКТУС>"}'

# запрос на получение новостей после авторизации
curl -i http://localhost:8055/items/news \
  -H "Authorization: Bearer <ПОЛУЧЕННЫЙ ТОКЕН>"

# команда внесения записей в БД (после добавления в репо файла с тестовыми данными seed-test-data.sql)
cat seed-test-data.sql | sudo docker compose --env-file .env exec -T postgres psql -U arctic_user -d arctic_pulse

# проверка успешности добавления (по кол-ву строк в таблицах)
cat <<'SQL' | sudo docker compose --env-file .env exec -T postgres psql -U arctic_user -d arctic_pulse
SELECT 'sources' AS table_name, count(*) FROM sources
UNION ALL
SELECT 'tags', count(*) FROM tags
UNION ALL
SELECT 'news', count(*) FROM news
UNION ALL
SELECT 'news_tags', count(*) FROM news_tags;
SQL

# КОМАНДЫ ДЛЯ ОТОБРАЖЕНИЯ СОЗДАННЫХ ТАБЛИЦ БД В ВЕБЕ ДИРЕКТУСА (оч много времени на это потрачено было)

sudo docker compose --env-file .env exec -T postgres psql -U arctic_user -d arctic_pulse -c "DROP TABLE IF EXISTS news_tags, news, tags, sources CASCADE;"

sudo docker compose --env-file .env exec -T postgres psql -U arctic_user -d arctic_pulse -f - < schema.sql

sudo docker compose --env-file .env exec -T postgres psql -U arctic_user -d arctic_pulse -c "\dt"

sudo docker compose --env-file .env restart directus

# перед этим добавление таблиц в БД
sudo docker compose exec -T postgres psql -U arctic_user -d arctic_pulse < schema.sql