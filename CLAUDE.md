# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Evidence tutorial project using BigQuery public datasets. Evidence (evidence.dev) is a SQL-based BI framework that generates reports from markdown files with embedded SQL queries.

## Setup

**1. BigQuery authentication (ADC)**
```bash
gcloud auth application-default login
```

**2. Environment variables**

Create `.env` in the project root:
```env
EVIDENCE_SOURCE__bq_public__project=<your-gcp-project-id>
```

**3. Install and run**
```bash
npm install
npm run sources      # Fetch data from BigQuery (caches locally)
npm run dev          # Start dev server at http://localhost:3000
```

## Commands

```bash
npm run sources                              # Update all data sources
npm run sources -- --sources bq_public       # Update only bq_public source
npm run build                                # Build static site
```

## Architecture

- `sources/bq_public/` — BigQuery data source (`bigquery-public-data.chicago_taxi_trips`)
  - `connection.yaml` — Connection config; GCP project set via `EVIDENCE_SOURCE__bq_public__project`
  - `*.sql` — Source queries, results cached locally under `.evidence/`
- `pages/` — Markdown report pages with embedded SQL and chart components
- `evidence.config.yaml` — Theme, plugins, and datasource registration

## Data Sources

| Source | Table | Description |
|--------|-------|-------------|
| `bq_public` | `bigquery-public-data.chicago_taxi_trips.taxi_trips` | Chicago taxi trip records |

Queries are referenced in pages as `bq_public.<query_name>` (e.g. `bq_public.monthly_trips`).
