from .main import app
from fastapi.testclient import TestClient


def test_read_main():
    client = TestClient(app)

    response = client.get("/")
    assert response.status_code == 200

def test_sessions_basic():
    client = TestClient(app)

    response = client.post("/api/v1/chat/start_session")
    session1 = response.json()['session_id'] 


    response = client.post("/api/v1/chat/start_session")
    session2 = response.json()['session_id']

    assert session1 != session2

    data1 = {
        "session_id" : session1,
        "prompt": "what is a good first plant"
    }
    data2 = {
        "session_id" : session2,
        "prompt": "what is a good second plant"
    }

    response1 = client.post("/api/v1/chat", json=data1)
    response2 = client.post("/api/v1/chat", json=data2)

    print(response1.text)

    assert response1.json()['response'] != response2.json()['response'] 

def test_chat_context():
    client = TestClient(app)

    response = client.post("/api/v1/chat/start_session")
    session_id = response.json()['session_id'] 

    body = {
        "session_id" : session_id,
        "prompt": "what is a good plant if i live in wyoming"
    }
    response = client.post("/api/v1/chat", json=body)


    body = {
        "session_id" : session_id,
        "prompt": "what state did i talk about in the last prompt"
    }
    response = client.post("/api/v1/chat", json=body)

    assert 'wyoming' in response.json()['response'].lower()

