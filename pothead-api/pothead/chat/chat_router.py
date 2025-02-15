from fastapi import APIRouter, HTTPException, Depends
from fastapi.responses import JSONResponse
from pothead.models import *
from .chat import *

router = APIRouter()


@router.post("/chat")
async def chat(payload: Prompt):
    response = await ask_harold(payload)
    if response == False:
        return JSONResponse({"response": "something went wrong, please try again later"}, status_code=404)
    return JSONResponse(response)

@router.post("/chat/start_session")
def start_session_route():
    response = start_session()
    print(response)
    return JSONResponse(response)

chat_router = router
