#!/usr/bin/env node
const path = require('node:path');
const express = require('express');

const app = express();
const port = Number(process.env.PORT || 8100);
const buildWebPath = path.resolve(__dirname, '..', 'build', 'web');

app.disable('etag');

app.use((req, res, next) => {
  res.setHeader('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0');
  res.setHeader('Pragma', 'no-cache');
  res.setHeader('Expires', '0');
  next();
});

app.use(express.static(buildWebPath, { index: 'index.html' }));

app.use((_req, res) => {
  res.sendFile(path.join(buildWebPath, 'index.html'));
});

app.listen(port, () => {
  console.log(`Web build local em http://localhost:${port}`);
  console.log(`Servindo pasta: ${buildWebPath}`);
});
