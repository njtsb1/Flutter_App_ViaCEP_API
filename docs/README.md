# Creating a Flutter App from Scratch to Consume the ViaCEP API

Project developed at Santander Bootcamp 2023 - Mobile with Flutter, under the guidance of specialist [Danilo Perez](https://github.com/perez-danilo "Danilo Perez").

In this challenge, you will have to build a Flutter application from scratch, putting into practice the concepts of asynchrony and API consumption.

## Features

- Fetch CEP details from ViaCEP API.
- Display address fields (street, neighborhood, city, state, IBGE, DDD, etc.).
- Save, edit, and delete CEP entries in `localStorage`.
- Dark / Light theme toggle with moon/sun icons.
- Multilanguage UI: **EN-US** (default), **PT-BR**, **ES**.
- Accessible markup, semantic elements, and responsive layout for desktop/tablet/mobile.

## Tecnologies Used

- **Dart (Flutter)**: developing the mobile application, implementing asynchronous API calls, state management, and the user interface.
- **AI (Assistive)**: providing contextual suggestions and accessibility improvements during development and testing.

## Tecnologies Add

- **HTML**: main HTML file.
- **CSS**: styles with dark and light theme variables.
- **JavaScript**: application logic, translations, theme and language persistence, ViaCEP fetch, localStorage management.

## Usage

1. Open `index.html` in a modern browser (Chrome, Firefox, Edge, Safari).
2. Enter a CEP (format `00000-000` or `00000000`) and click **Fetch**.
3. If the CEP is found, click **Save** to store it locally.
4. Use the language selector to switch UI language.
5. Toggle theme with the moon/sun button. Preference is saved.

![CEP Finder](assets/CEP_Finder.png)

## Accessibility & Responsiveness

- Uses semantic HTML (`header`, `main`, `section`, `footer`).
- Buttons and inputs include ARIA attributes where appropriate.
- `aria-live` regions announce status and results to assistive technologies.
- Layout adapts to small screens and larger viewports.

## Notes

- This is a lightweight demo intended for local use and learning.
- Saved CEPs are stored in the browser `localStorage` and are not synced to a server.
- ViaCEP is a public API; use responsibly and consider rate limits for heavy usage.

[LICENSE](./LICENSE)
