import express from 'express';
import pg from 'pg';

const app = express();
const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });
const port = Number(process.env.PORT ?? 3000);

app.use(express.json());

app.get('/health', async (_req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok', db: 'up' });
  } catch {
    res.status(503).json({ status: 'degraded', db: 'down' });
  }
});

app.get('/events', async (_req, res) => {
  const { rows } = await pool.query('SELECT id, title, starts_at FROM events ORDER BY starts_at');
  res.json(rows);
});

app.post('/events', async (req, res) => {
  const { title, startsAt } = req.body ?? {};
  if (!title || !startsAt) {
    res.status(400).json({ error: 'title et startsAt requis' });
    return;
  }
  const { rows } = await pool.query(
    'INSERT INTO events (title, starts_at) VALUES ($1, $2) RETURNING id, title, starts_at',
    [title, startsAt],
  );
  res.status(201).json(rows[0]);
});

app.listen(port, () => console.log(`EventHub API sur http://localhost:${port}`));
