# tmux: медленный ввод в сессии moshi

**Дата:** 2026-03-18
**Сессия:** moshi

## Симптомы

Сессия tmux очень медленно реагирует на ввод (переключение окон, набор текста).

## Причины

### 1. Зависшие процессы (основная причина)

Два pytest-процесса (`python -m pytest tests/unit/airflow/`) висели с 16 марта, потребляя 200% CPU (99.9% каждый, ~2650 часов CPU time). Это забивало CPU и тормозило весь tmux-сервер.

Решение: `sudo kill -9 <pid>`

### 2. I/O wait от Spark на HDD (основная причина после kill pytest)

Все Docker volumes, репозитории и Minio data лежат на HDD (`sda`, `/media/bas/data`). Spark в режиме `local[8]` с тяжёлым shuffle забивает очередь I/O на HDD — остальные процессы (git, docker healthchecks, tmux) встают в очередь. I/O wait доходил до 51-59%, 30-46 процессов в D-state.

Диагностика:
```bash
vmstat 1 3                              # wa% — I/O wait
ps aux | awk '$8 ~ /D/ {print}'         # процессы в D-state (ждут I/O)
```

Решение — понизить I/O приоритет Spark до idle:
```bash
sudo ionice -c 3 -p <spark_pid>         # idle I/O priority
sudo renice 19 -p <spark_pid>           # low CPU priority (опционально)
```

Результат: I/O wait упал с 51-59% до 13-16%, blocked processes с 32-46 до 6-10.

### 3. Большой scrollback (вторичная причина)

Python-процессы в окнах генерировали большой объём вывода. Scrollback buffer накапливал до 75-77 MB (37000-42000 строк из 50000 лимита).

Решение:
```bash
# Очистить scrollback для конкретного окна
tmux clear-history -t moshi:<window>

# Очистить все окна сессии
for w in $(tmux list-windows -t moshi -F '#{window_index}'); do
  tmux clear-history -t "moshi:$w"
done
```

## Диагностика

```bash
# 1. I/O wait — главный индикатор
vmstat 1 3                              # колонка wa%: >20% = проблема

# 2. CPU — зависшие процессы
ps aux --sort=-%cpu | head -20

# 3. D-state — процессы заблокированные на I/O
ps aux | awk '$8 ~ /D/ {print}'

# 4. Scrollback
tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}: #{history_bytes} bytes' \
  | awk -F': ' '{gsub(/ bytes/,"",$2); if ($2+0 > 5000000) print}'
```

## Инфраструктура

```
nvme0n1 (SSD 477G) → /           — ОС, /tmp
sda     (HDD 932G) → /media/bas/data — репозитории, Docker volumes, Minio
```

Все тяжёлые I/O (Spark, Postgres, MSSQL, Neo4j, Minio) — на HDD.

## Профилактика

- **ionice** для тяжёлых процессов: `sudo ionice -c 3 -p <pid>`
- Ограничить tmux history-limit: `tmux set -t <session> history-limit 5000`
- Перенаправлять вывод долгоживущих процессов в файл
- Следить за зависшими процессами: долгоживущие pytest/python без прогресса — кандидаты на kill
