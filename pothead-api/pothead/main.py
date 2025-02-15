from fastapi import FastAPI
from pothead.models import * 
from dotenv import load_dotenv
from pothead.chat.chat_router import chat_router


app = FastAPI()
load_dotenv()

@app.get("/")
def read_root():
    return {"message": "Hello World!"}

app.include_router(chat_router, prefix="/api")
