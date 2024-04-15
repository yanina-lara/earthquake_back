# README

This README provides steps to get the application up and running.

## Prerequisites

- Ruby version: 3.1.4
- PostgreSQL: Ensure PostgreSQL is installed on your system.

## Configuration

1. Configure the `database.yml` file with your database settings.
   
2. Run database initialization commands:

    `rails db:create`
   
    `rails db:migrate`

To fetch earthquake data, execute:

 `rake earthquake:fetch_data`

Start the Rails server on port 4000 with:

 `rrails s -p 4000`




