# STUB containers for PACTA application

This repo defines 2 stub containers: `portfolio_parser` and `report_runner`.

`docker-compose.yml` contains a working (local) example.

## Local invokation

```sh
docker-compose up --build portfolio_parser
```

Then copy one of the UUID filenames in `/mount/processed_portfolios/` to the `PORTFOLIO` envvar for `report_runner` and:

```sh
docker-compose up --build report_runner
```

report file will exist at `/mount/reports/<PORTFOLIO ID>`

## `portfolio_parser`

Intended to simulate portfolio validation and parsing logic.
This container is the link between the raw portfolio CSV files that users upload, and the internal JSON format that we will be using.

Prerequisites:

* `USERID` Environment variable
* Volume Mount from directory containing portfolios to be processed to `/mnt/raw_portfolios`
* Volume Mount from directory to contain processed portfolios to `/mnt/processed_portfolios`

Note that this copntainer simulates the linkage between portfolio files and user IDs, contained in `processed_portfolios/00-database.csv`

## `report_runner`

Creates report `index.html` and assosciated files from a processed portfolio JSON file

Prerequisites:

* `PORTFOLIO` Environment variable containing portfolio JSON filename (sans extension)
* Volume Mount from directory containing processed portfolios to `/mnt/processed_portfolios`
* Volume Mount from directory to contain reports to `/mnt/reports`
