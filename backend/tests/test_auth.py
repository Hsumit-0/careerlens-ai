import pytest
from httpx import AsyncClient


@pytest.mark.asyncio
async def test_health_check(client: AsyncClient):
    response = await client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "CareerLens AI" in data["project"]


@pytest.mark.asyncio
async def test_register_user(client: AsyncClient):
    payload = {
        "email": "test@careerlens.ai",
        "password": "Password123!",
        "full_name": "Test Candidate"
    }
    response = await client.post("/api/v1/auth/register", json=payload)
    assert response.status_code == 201
    data = response.json()
    assert "access_token" in data
    assert "refresh_token" in data
    assert data["user"]["email"] == "test@careerlens.ai"
    assert data["user"]["full_name"] == "Test Candidate"


@pytest.mark.asyncio
async def test_login_user(client: AsyncClient):
    # Register first
    reg_payload = {
        "email": "login@careerlens.ai",
        "password": "SecurePassword123!",
        "full_name": "Login User"
    }
    await client.post("/api/v1/auth/register", json=reg_payload)

    # Login via JSON
    login_payload = {
        "email": "login@careerlens.ai",
        "password": "SecurePassword123!",
        "full_name": "Login User"
    }
    response = await client.post("/api/v1/auth/login/json", json=login_payload)
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert "refresh_token" in data


@pytest.mark.asyncio
async def test_refresh_token_flow(client: AsyncClient):
    reg_payload = {
        "email": "refresh@careerlens.ai",
        "password": "SecurePassword123!",
        "full_name": "Refresh User"
    }
    reg_res = await client.post("/api/v1/auth/register", json=reg_payload)
    refresh_token = reg_res.json()["refresh_token"]

    # Refresh access token
    refresh_res = await client.post(
        "/api/v1/auth/refresh",
        json={"refresh_token": refresh_token}
    )
    assert refresh_res.status_code == 200
    refreshed_data = refresh_res.json()
    assert "access_token" in refreshed_data
    assert "refresh_token" in refreshed_data
    assert refreshed_data["refresh_token"] != refresh_token  # Refresh token rotation


@pytest.mark.asyncio
async def test_get_current_user_me(client: AsyncClient):
    reg_payload = {
        "email": "me@careerlens.ai",
        "password": "SecurePassword123!",
        "full_name": "Me User"
    }
    reg_res = await client.post("/api/v1/auth/register", json=reg_payload)
    access_token = reg_res.json()["access_token"]

    headers = {"Authorization": f"Bearer {access_token}"}
    me_res = await client.get("/api/v1/auth/me", headers=headers)
    assert me_res.status_code == 200
    user_data = me_res.json()
    assert user_data["email"] == "me@careerlens.ai"
    assert user_data["full_name"] == "Me User"


@pytest.mark.asyncio
async def test_unauthorized_access(client: AsyncClient):
    response = await client.get("/api/v1/auth/me")
    assert response.status_code == 401
