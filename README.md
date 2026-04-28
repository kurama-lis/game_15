## Running in development mode

Dependencies:
- Ruby 3.1
- PostgreSQL
- Node.js

Fill credentials in `.env` file as
```
VIDEO_RAILS_23_DEV_DATABASE_USERNAME=your_postgres_username
VIDEO_RAILS_23_DEV_DATABASE_PASSWORD=your_postgres_password
```

Install dependencies:
```bash
bundle install
npm install
```
Run the frontend dev build:

```bash
foreman start -f Procfile.dev
```

Run the web server from IDE or from terminal with
```bash
rails s
```