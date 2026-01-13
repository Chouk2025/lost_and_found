# Lost & Found Mobile Application

A full-stack mobile application built with Flutter that allows users to report and browse lost or found items. Users can view item details, including contact information, and add new items through a simple form.

## Features
- View a list of lost and found items
- View detailed information for each item
- Add new lost or found items
- Data stored online in a database
- Real-time data retrieval from a backend service

## Technologies Used
- **Flutter (Dart)** – Mobile frontend
- **PHP** – Backend services (API)
- **MySQL** – Database
- **HTTP & JSON** – Communication between frontend and backend

## Application Structure
The application consists of three main screens:
1. **Items List Screen** – Displays all lost and found items
2. **Item Details Screen** – Shows full item information and contact details
3. **Add Item Screen** – Allows users to submit new items

## Architecture
The Flutter app communicates with a PHP backend hosted on AwardSpace using HTTP GET and POST requests. The backend interacts with a MySQL database to store and retrieve data, returning responses in JSON format.

## Backend
The backend includes:
- A database connection file
- An endpoint to retrieve items
- An endpoint to add new items

Database credentials are omitted from this repository for security reasons.

## Database
The database schema is provided in the `database/schema.sql` file and includes the table used to store lost and found items.

## Notes
This project was originally developed as part of a university course and is shared here for learning and portfolio purposes.
