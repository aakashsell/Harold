from pydantic import BaseModel, EmailStr


class Prompt(BaseModel):
    session_id: int | None = 0
    prompt: str

class ActionResponse(BaseModel):
    plant_name: str
    prompt: str
    action_items: list[str]

class SimpleResponse(BaseModel):
    prompt: str
    response: str
    plants_stated: list[str]
    specific_products: list[str]


class User(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    zip_code: int

