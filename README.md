# Quizly — Online Quiz Application

A collaborative full-stack learning project connecting a React interface, a Java/Spring Boot quiz API and MySQL, with a separate Python AI service and an optional C# logging endpoint.

Quizly brings the quiz lifecycle into one application: instructors author and publish quizzes, students take timed attempts and review answers, and administrators manage accounts, courses and performance metrics.

**Stack:** Java 21 · Spring Boot 4 · Spring Security · Spring Data JPA · MySQL · React 19 · Vite · FastAPI · Pydantic · ASP.NET Core

**Status:** implementation available for local development. This README describes inspected source; it does not claim a verified public deployment, measured learning gains or production scale.

## Main flows

| Role | Workflow |
| --- | --- |
| Student | Register for courses → start or resume a timed attempt → submit → review answers and results |
| Instructor | Create a draft → add questions and explanations → set timer/pass threshold → publish → inspect results |
| Administrator | Manage users, roles and courses → inspect quiz and attempt metrics |
| AI assistance | Generate editable question drafts, request progressive hints or evaluate an open response against a rubric |

## Architecture

```text
React → Spring Boot REST API → MySQL
      → FastAPI AI service → Gemini
Spring Boot / AI service → optional ASP.NET Core logging endpoint
```

The API validates signed JWTs and checks role/account/quiz/attempt ownership. Timed attempts keep a server deadline, so refreshing does not reset an active timer. User credentials live in a shared user table; student and instructor profiles use related tables.

AI output is validated with Pydantic, but schema validation does not establish factual correctness. Generated questions and evaluations need human review.

## Prerequisites

- JDK 21 (the backend Maven configuration targets Java 21).
- Node.js compatible with Vite 8 and npm.
- MySQL, with a local database and account matching your configuration.
- Python with a virtual environment for the AI service.
- .NET 8 SDK for the optional logging service.
- A Gemini API key for AI operations; normal quiz functionality is separate from model calls.

## Features in the source

- Student profiles, course enrollment, timed attempts, reattempts and answer review.
- Instructor draft/publish workflows, questions, explanations, timers and passing thresholds.
- Admin account, role and course management; performance metrics and activity logs.
- XP-based leaderboards, pass bonuses, levels, streaks and role-specific analytics.
- Signed JWT authentication, password hashing and ownership checks.
- Gemini-backed question drafts, progressive hints and rubric-based open-response evaluation.

## Repository map

| Path | Responsibility |
| --- | --- |
| `frontend/` | React/Vite interface with separate auth, student, instructor, admin and common components |
| `backend/` | Spring Boot REST API, services, repositories and MySQL entities |
| `ai-service/` | FastAPI, Gemini integration and Pydantic response validation |
| `logging-service/` | Optional ASP.NET Core logging endpoint |
| `database_schema.sql` | Database schema for reviewed deployment setup |
| `run-all.sh` | Local launcher and service logs |

## Configure locally

Copy `backend/.env.properties.example` to `backend/.env.properties` and set your database connection, service URLs and a random JWT secret of at least 32 characters. Create the MySQL database named in `DB_URL`.

```properties
DB_URL=jdbc:mysql://localhost:3306/quiz_app
DB_USERNAME=your_local_user
DB_PASSWORD=your_local_password
SERVER_PORT=8080
LOGGING_SERVICE_URL=http://localhost:5050
JWT_SECRET=replace_with_at_least_32_random_characters
JWT_EXPIRATION_HOURS=12
```

Copy `ai-service/.env.example` to `ai-service/.env`. Set `GEMINI_API_KEY`, the configured `GEMINI_MODEL`, and the same `JWT_SECRET` as the Java API. Keep keys in ignored local configuration. The AI service also supports shared settings from the backend configuration.

## Run

From the repository root, after configuring the database and prerequisites:

```sh
./run-all.sh
```

The launcher can start MySQL through Homebrew, prompts for a missing Gemini key and stores it in the ignored AI environment file, starts the services, and writes service output to `logs/`. Ctrl+C stops application processes started by the launcher; MySQL stays running.

To run services separately:

1. Start MySQL and create the database matching `DB_URL`.
2. In `ai-service/`, create and activate a virtual environment, install `requirements.txt`, and run `uvicorn main:app --env-file .env --reload --port 8000`.
3. In `backend/`, run `./mvnw spring-boot:run`.
4. In `logging-service/`, run `dotnet run` if using the logging endpoint.
5. In `frontend/`, run `npm install`, then `npm run dev`.
6. Open `http://localhost:5174` (or the URL printed by Vite).

The frontend defaults to `http://localhost:8000/api` for AI calls; configure `VITE_AI_API_URL` for another location. Spring API docs: `http://localhost:8080/swagger-ui.html`; raw schema: `http://localhost:8080/v3/api-docs`. AI docs: `http://localhost:8000/docs`. Protected calls use `Authorization: Bearer <token>` returned by login.

## Sample data and persistence

Normal local startup uses `ddl-auto=update` and preserves quizzes and attempts across backend restarts. The explicit reset profile replaces development data with sample records; use a disposable local database for it:

```sh
cd backend
./mvnw spring-boot:run -Dspring-boot.run.profiles=reset
```

The sample includes all three roles, course enrollments, draft/published quizzes and passed/failed/auto-submitted attempts. Sample accounts use `password123`:

```text
Admin:      admin@quizly.local
Instructor: maya.instructor@quizly.local
Instructor: daniel.instructor@quizly.local
Student:    aarav.student@quizly.local
Student:    sara.student@quizly.local
Student:    noah.student@quizly.local
Student:    meera.student@quizly.local
```

## Authentication and authorization

New passwords use salted JDK PBKDF2 hashes. Existing plain-text development records are upgraded after successful login. Login and registration return signed JWTs, stored for the current browser tab and sent as Bearer tokens. Spring Security uses stateless authentication; routes and service methods enforce roles and account/quiz/attempt ownership. Tokens expire after 12 hours by default. Changing `JWT_SECRET` invalidates existing tokens. Per-user immediate revocation and refresh-token support are further work.

Shared credentials live in `users`; student/instructor profile tables share their primary keys with the user row. This avoids duplicating login details.

## Main API

```text
POST /api/auth/register
POST /api/auth/login
GET  /api/courses
GET  /api/students/{id}/profile
GET  /api/instructors/{id}/profile
GET  /api/quizzes/student/{studentId}
GET  /api/quizzes/instructor/{instructorId}
POST /api/quizzes
PUT  /api/quizzes/{id}
POST /api/quizzes/{id}/questions?instructorId=2
POST /api/attempts/start?quizId=1&studentId=6
POST /api/attempts/{attemptId}/submit
GET  /api/attempts/{attemptId}/review?studentId=6
GET  /api/quizzes/{quizId}/answer-key?instructorId=2
DELETE /api/quizzes/{quizId}?instructorId=2
GET  /api/admin/metrics
GET  /api/admin/users
POST /api/admin/users
PATCH /api/admin/users/{id}/role
POST /api/admin/courses
```

Quiz deletion is limited to the owning instructor and blocked once a student attempt exists, preserving score and review history. Custom queries are kept in `QuizRepository`, `CourseRepository` and `QuizAttemptRepository`.

## Activity logging

The backend persists activity records locally and forwards them to the optional C# endpoint asynchronously. Logging failures do not fail the original action. Events cover authentication, administration, enrollments, quizzes, attempts, reviews and AI operations. AI logs include operation type, duration and actor ID, excluding prompts, notes, answers and generated text.

## Validation and deployment limits

Python AI service tests are present in `ai-service/test_main.py`. Their presence is not a claim that the full application or a public deployment has been validated in this documentation update. No automated Java test suite is checked in. Add regression coverage for role/ownership rejection, timer expiry, duplicate submissions and quiz deletion after attempts.

For production, review/apply `database_schema.sql`, provision the first administrator through a controlled database process, configure real HTTPS origins with `CORS_ALLOWED_ORIGINS`, and build the frontend with `VITE_API_URL` and `VITE_AI_API_URL`. Keep the Gemini key in the Python service only, and configure backups, monitoring and a dedicated security review.

```sh
java -jar target/quiz_backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod
```

The production profile validates the schema, hides internal errors, disables SQL printing, requires an explicit JWT secret and disables automatic development-admin creation. Do not use reset/sample profiles on production data.
