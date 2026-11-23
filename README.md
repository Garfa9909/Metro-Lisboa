# Metro Lisboa App

A Flutter mobile application for checking Lisbon Metro stations, waiting times, and real-time geolocation on an interactive map, built with offline-first support.

## Features

- **Station Directory & Details:** Browse all Lisbon Metro stations, view detailed station information, and check real-time waiting times.
- **Interactive Map:** Locate stations across Lisbon and track your current position in real time.
- **Offline Support:** Automatically caches station data locally so you can access station lists, details, and maps without an internet connection.
- **Incident Reports:** View and access service incident reports directly from local storage.

## Architecture & Data Flow

The application follows a **Repository Pattern** to abstract data sources and seamlessly switch between online and offline modes:

- **Initial Synchronization:** The app fetches station data from the **Metro Lisboa API**. Once retrieved, all stations are persisted into the local SQLite database (`sqflite`), enabling full offline access afterward.
- **Dynamic Data Retrieval:** When navigating to the **List**, **Map**, or **Details** screen, the UI requests station data from the `MetroRepository`:
  - **Online Mode:** The repository queries the **HTTP Datasource** to fetch the latest real-time information from the API.
  - **Offline Mode:** The repository falls back to the **sqflite Datasource** to load cached station data from the local database.
- **Incident Reports:** Incident reports are retrieved directly from the local `sqflite` database in all scenarios (both online and offline).

## Tech Stack

- **Framework:** Flutter & Dart
- **Local Persistence:** `sqflite` (SQLite)
- **Networking:** HTTP client consuming the Metro Lisboa API
- **Maps & Location:** Interactive map view with real-time device geolocation

# Screenshots

## List

<img width="482" height="788" alt="image" src="https://github.com/user-attachments/assets/471214a6-6aac-41d9-80b3-909b93328372" />

## Map

<img width="479" height="794" alt="image" src="https://github.com/user-attachments/assets/c08f6150-588c-4ede-a877-9f32c84b8e44" />

## Details

<img width="472" height="788" alt="image" src="https://github.com/user-attachments/assets/dfcaa18b-0391-4392-980b-155833033e8b" />

## Report Incident

![Report Incident](assets/screenshots/report.png)






