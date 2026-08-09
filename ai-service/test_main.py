import os

os.environ.setdefault("JWT_SECRET", "quizly-local-development-secret-change-before-production")

import jwt
from fastapi.testclient import TestClient

import main


client = TestClient(main.app)


def token(user_id: int, role: str) -> str:
    return jwt.encode({"sub": user_id, "role": role}, main.JWT_SECRET, algorithm="HS256")


def test_shared_gemini_configuration_is_loaded() -> None:
    assert main.GEMINI_API_KEY
    assert main.GEMINI_MODEL


def test_health() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["provider"] == "gemini"


def test_ai_route_requires_authentication() -> None:
    response = client.post("/api/ai/hint", json={
        "question": "What is inheritance?", "options": "", "level": 1, "actorId": 6
    })
    assert response.status_code == 401


def test_instructor_route_rejects_student() -> None:
    response = client.post(
        "/api/ai/questions/generate",
        headers={"Authorization": f"Bearer {token(6, 'ROLE_STUDENT')}"},
        json={"topic": "Java", "notes": "", "difficulty": "medium", "count": 2, "actorId": 6},
    )
    assert response.status_code == 403


def test_actor_must_match_token() -> None:
    response = client.post(
        "/api/ai/hint",
        headers={"Authorization": f"Bearer {token(6, 'ROLE_STUDENT')}"},
        json={"question": "What is inheritance?", "options": "", "level": 1, "actorId": 7},
    )
    assert response.status_code == 403


def test_spring_instructor_role_is_accepted() -> None:
    user = main.current_user(f"Bearer {token(2, 'ROLE_INSTRUCTOR')}")
    assert user.id == 2
    assert user.role == "ROLE_INSTRUCTOR"


def test_gemini_schema_removes_unsupported_validation_keywords() -> None:
    schema = main.gemini_schema(main.EvaluationResponse)
    assert schema["type"] == "object"
    assert "title" not in schema
    assert "maxLength" not in schema["properties"]["feedback"]
    assert schema["properties"]["strengths"]["items"] == {"type": "string"}


def test_generated_question_schema_resolves_nested_pydantic_reference() -> None:
    schema = main.gemini_schema(main.GeneratedQuestions)
    question = schema["properties"]["questions"]["items"]
    assert set(question["properties"]) == {
        "questionText", "options", "correctIndex", "explanation", "skillTag", "difficulty"
    }
    assert question["properties"]["options"]["items"] == {"type": "string"}
