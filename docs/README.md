# Creating a Flutter App from Scratch to Consume the ViaCEP API

Project developed during the Santander Bootcamp 2023 - Mobile with Flutter, under the guidance of [Danilo Perez](https://github.com).

This project implements a ZIP code (CEP) finder application that serves as a web prototype designed to simulate and architecture the requirements of a Flutter mobile application consuming asynchronous APIs.

## Features

- **ViaCEP API Consumption**: Fetches real-time address details (street, neighborhood, city, state, IBGE, DDD) using asynchronous requests.
- **Local Address Management**: Save, edit, and delete fetched CEP entries.
- **Multi-language UI**: Support for English (EN-US), Portuguese (PT-BR), and Spanish (ES) with runtime switching.
- **Dark / Light Mode**: Theme toggle with user preference persisted in `localStorage`.
- **Accessibility & Responsiveness**: Semantic layout, ARIA attributes, keyboard navigation, and a fluid design optimized for mobile viewports, tablets, and desktop.

## Tech Stack

### Core Architecture & Logic
- **Dart / Flutter (Concept)**: Asynchronous workflow mapping, state management logic, and API data structuring.
- **AI Assistive Tech**: Simulated assistance for smart contextual suggestions and accessibility UX improvements.

### Web Interface & Mock Container
- **HTML5**: Semantic markup, accessible controls, and ARIA integration.
- **CSS3**: Core variables for dark/light themes, responsive layout, and focus states.
- **JavaScript**: Core logic for the ViaCEP fetch lifecycle, i18n translation engine, and local state persistence.

## How to Run

1. Open `index.html` directly in any modern browser (Chrome, Firefox, Edge, Safari).
2. Enter a Brazilian CEP (e.g., `00000-000` or `00000000`) and click **Fetch**.
3. If the address is found, click **Save** to store it locally.
4. Toggle language and theme preferences; they will persist for future visits.

## Data Persistence & Notes

- **Storage**: Saved CEPs are stored locally in the browser's `localStorage` for demo convenience and are not synchronized with an external server database.
- **API Limits**: ViaCEP is a free, public API. It is used here directly via client-side requests for learning and local prototyping purposes.

## Accessibility Details

- Built using semantic tags (`header`, `main`, `section`, `footer`) for proper screen reader indexing.
- Interactive controls feature visible focus outlines.
- `aria-live` regions announce API status changes and search results dynamically to assistive technologies.

![CEP Finder Preview](assets/CEP_Finder.png)

[LICENSE](./LICENSE)
