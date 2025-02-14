from typing import Union

from fastapi import FastAPI
from fastapi.responses import JSONResponse


from chat import *
from pydantic import BaseModel

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


class Prompt(BaseModel):
    prompt: str

@app.post("/api/chat")
async def chat(payload: Prompt):
    response = ask_harold(payload.prompt)
    return JSONResponse(response)