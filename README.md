### QA Automation - Sandman

This repository contains Robot Framework automation for the QCe/LPS applications. It uses Selenium for browser automation, Requests for API interactions, and Faker for generating test data.

## Environment Variables (.env)
Accounts and secrets are not committed. Create a `.env` file in the project root. The keywords in `resources/env.resource` load these variables and expose them as suite variables. At minimum, provide a public applicant email and password. Role-based credentials can be added as needed following the naming pattern reflected in `resources/env.resource` and `LPS/testing-creds.txt`.

How it works:
- `resources/env.resource` provides `Load Environment`, `Get Env`, `Set Public Applicant From Env`, and `Set All Creds From Env`.
- `resources/QCe-site.resource` imports `env.resource`, site URLs, and browser helpers.

## Project Structure
- `LPS`
- `Biz Retirement (Currentnly not working on it yet)`

## Tips
- Always call `Load Environment` at the start of your suite/setup, then `Set Public Applicant From Env` or `Set All Creds From Env` as needed.
- Review the module `.md` guides inside each folder for process details.

## Troubleshooting
- If the browser fails to start, ensure your browser (supported by robotframework) is installed and you’re not missing any needed libraries.
- Verify your `.env` is in the project root and variables are correctly named (see above list).