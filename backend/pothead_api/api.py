from ninja import NinjaAPI, Schema
from pydantic import BaseModel
from .models import *
from .chat import *



api = NinjaAPI()

@api.post("/add-plant/")
def add_plant(request, owner, name, description, health):
    plant = Plant.objects.create(
        owner=owner,
        name=name,
        description=description,
        health=health
    )
    plant.save()
    return {"message": "Plant added successfully"}

@api.post("/add-user/")
def add_user(request):
    user = User.objects.create()
    user.save()
    return {"message": user.id}




class ChatRequest(Schema):
    prompt: str

@api.post("/chat/")
def chat(request, data: ChatRequest):

    prompt = 
    response = get_response(data.prompt)
    return response

    