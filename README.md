# README

This is a boilerplate project for a Rails application in Kawanlama Group. It is a simple project that uses Stimulus for frontend and Rails for backend.

Features:
- Stimulus for frontend
- Postgres for database
- Solid Trifecta:
  - Solid Queue
  - Solid Cache
  - Solid Cable (Optional)
- RSpec for testing
- Auth using Devise

## Quick Start

### Clone this repository

```bash
git clone git@github.com:KLG-tech/rails-stimulus-boilerplate.git
cd rails-stimulus-boilerplate
```

### Create a `.env` file

```bash
cp .env.example .env
```

Adjust the `.env` file with your own credentials.

### Install dependencies

### Run `bin/setup --skip-server` to install dependencies and prepare the database

The setup script will:
- Install dependencies
- Rename the project
- Set up git hooks
- Prepare the database  

### Run development server

```bash
bin/dev
```
