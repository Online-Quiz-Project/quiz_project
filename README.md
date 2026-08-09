# Quizly

A multi-role online quiz application with competitive learning features.

- Students see their profile, courses, available quizzes, timed attempts, and results.
- Students can reattempt a completed quiz; every reattempt receives a new server timer and attempt row.
- Instructors create quizzes, add questions, set timers and passing percentages, save drafts, and publish.
- Administrators see user, course, quiz, attempt, pass/fail, and score metrics.
- Live leaderboards refresh automatically and rank students by earned XP.
- Students earn pass bonuses, levels, and streaks.
- Students, instructors, and administrators receive role-specific performance analytics.
- Activity logs are stored for the in-app audit stream and forwarded to the C# logging service.
- Instructors can generate editable question drafts from topics or lesson notes.
- Students can request progressive AI hints without exposing the correct answer.
- The backend can evaluate open responses against an explicit rubric with a confidence score.
- A separate Python service uses Gemini and validates structured AI responses with Pydantic.
- Instructors can inspect the complete answer key for their published quizzes.
- Students can review selected answers, correct answers, and explanations after submission.
- Login and multi-course student registration use database-backed REST endpoints.
- Spring Security validates signed JWTs and enforces role, account, quiz, and attempt ownership.

Shared account fields are stored in `users`. Student-only fields are stored in
`students`, and instructor-only fields are stored in `instructors`. Both profile
tables share their primary key with the related user, so role information is
separate without duplicating login details.

## Structure

```text
frontend/          React and Vite interface
frontend/src/components/  Separate auth, student, instructor, admin, and common components
frontend/src/services/    Small API service files grouped by role
backend/           Spring Boot REST API with MySQL
ai-service/        FastAPI service for Gemini-backed generation, hints, and evaluation
logging-service/   Minimal ASP.NET Core logging endpoint
```

## Configuration

`backend/src/main/resources/application.properties` imports `backend/.env.properties`.
The AI service reads its settings from the shell environment; copy
`ai-service/.env.example` when using an environment loader.

```properties
DB_URL=jdbc:mysql://localhost:3306/quiz_app
DB_USERNAME=root
DB_PASSWORD=your_password
SERVER_PORT=8080
LOGGING_SERVICE_URL=http://localhost:5050
JWT_SECRET=replace_with_at_least_32_random_characters
JWT_EXPIRATION_HOURS=12

GEMINI_API_KEY=your_google_ai_studio_key
GEMINI_MODEL=gemini-3.1-flash-lite
AI_SERVICE_PORT=8000
```

## Run

### Run everything with one command

After creating `backend/.env.properties` and installing the prerequisites, run:

```bash
./run-all.sh
```

The launcher starts MySQL through Homebrew when possible and every Quizly
service. On first run it securely prompts for the Gemini key and stores it in
the ignored `ai-service/.env` file. It prints the application URLs when
they are ready and stores individual service output in `logs/`. Press Ctrl+C to
stop the application processes started by the launcher.

### Run services separately

1. Start MySQL and create the database from `DB_URL`.
2. Copy `ai-service/.env.example` to `ai-service/.env`, add a Gemini API key, and
   set `JWT_SECRET` to exactly the same value used by Spring Boot.
3. In `ai-service`, create a virtual environment, install `requirements.txt`, and
   start `uvicorn main:app --env-file .env --reload --port 8000`.
4. In `backend`, run `./mvnw spring-boot:run`.
5. In `logging-service`, run `dotnet run`.
6. In `frontend`, run `npm install` once and then `npm run dev`.
7. Open `http://localhost:5174`.

The frontend uses `http://localhost:8000/api` for AI calls by default. Set
`VITE_AI_API_URL` when the Python service is hosted elsewhere. Interactive AI
API documentation is available at `http://localhost:8000/docs`.

## Swagger API page

Start the backend and open:

```text
http://localhost:8080/swagger-ui.html
```

Use the token returned by login as `Authorization: Bearer <token>` when testing
protected endpoints from Swagger or another API client.

The raw generated OpenAPI description is available at
`http://localhost:8080/v3/api-docs`.

## Sample data

Normal development startup uses `ddl-auto=update`, so instructor-created quizzes,
attempts, responses, and review data survive backend restarts:

```bash
cd backend
./mvnw spring-boot:run
```

To intentionally replace development data with the demonstration records, use
the explicit reset profile:

```bash
cd backend
./mvnw spring-boot:run -Dspring-boot.run.profiles=reset
```

The sample covers admin, instructor, and student roles, multiple courses per
instructor and student, published and draft quizzes, both question types, and
passed, failed, and automatically submitted attempts. All sample accounts use
the password `password123`:

```text
Admin:      admin@quizly.local
Instructor: maya.instructor@quizly.local
Instructor: daniel.instructor@quizly.local
Student:    aarav.student@quizly.local
Student:    sara.student@quizly.local
Student:    noah.student@quizly.local
Student:    meera.student@quizly.local
```

## Password storage

New passwords are salted and hashed with the JDK's PBKDF2 implementation.
Existing plain-text development records remain usable and are upgraded to a
hash automatically after the next successful login.

## Authentication and authorization

Login and registration return a signed JWT that the frontend stores for the
current browser tab and sends as a Bearer token. Spring Security validates the
token without creating a server session. Admin routes require the admin role,
and student/instructor routes verify both the role and the account ID in the
request. Quiz ownership and attempt ownership are also checked in the service
layer.

Set `JWT_SECRET` to at least 32 random characters. Tokens expire after 12 hours
by default; change `JWT_EXPIRATION_HOURS` when needed. Changing the secret signs
everyone out immediately.

## Main API

```text
GET  /api/students/{id}/profile
GET  /api/instructors/{id}/profile
POST /api/auth/register
POST /api/auth/login
GET  /api/courses
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

Custom queries are intentionally short and kept in `QuizRepository`, `CourseRepository`, and `QuizAttemptRepository`.

Quiz deletion is limited to the owning instructor and is blocked after any
student attempt exists, preserving historical scores and answer reviews.

## Activity logging

The backend stores important events locally and forwards them to the optional
logging service without delaying or failing the original action. Logging now
covers authentication, administration, enrollments, quiz lifecycle, attempt
lifecycle, reviews, and successful or failed AI operations. AI logs include
only operation type, duration, and actor ID; prompts, notes, answers, generated
questions, and hint text are deliberately excluded.

## Before production

Before a public production launch, add refresh-token or forced-revocation
support if your operational requirements need immediate per-user logout, and
perform a dedicated security review.

Remaining operational steps include:

Use the production profile:

```bash
java -jar target/quiz_backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod
```

Before starting it:

1. Apply and review `database_schema.sql`.
2. Create the first administrator directly through a controlled database process.
   Automatic `admin123` creation is disabled in production.
3. Set the required database and service environment values.
4. Set `CORS_ALLOWED_ORIGINS` to the real HTTPS frontend origin only.
5. Build the frontend with `VITE_API_URL` and `VITE_AI_API_URL` set to their
   public HTTPS API URLs.
6. Keep the Gemini key only in the Python AI service environment; never expose
   it to browsers or commit it to Git.
7. Put the public services behind HTTPS and configure backups and monitoring.
8. Do not use the `reset` or `sample` profiles in production.

The production profile validates rather than changes the schema, hides internal
server errors, disables SQL printing, requires an explicit JWT secret, and
disables the automatic development administrator.
