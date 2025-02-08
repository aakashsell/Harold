from ninja import NinjaAPI, Schema
from pydantic import BaseModel
from .models import *
from .chat import *
from django.http import JsonResponse



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

@api.post("/plant-health/")
def plant_health(request):
    species = "sunflower"
    health = 100
    days_since_last_water = 2
    prompt = f"""My plant is a {species} and its health is currently at {health}%.
    it has been {days_since_last_water} days since I last watered it.
    Please give verbose and personable action items to help my plant thrive."""
    response = plant_action_itmes(prompt)
    return response

@api.post("/chat/")
def chat(request, payload: ChatRequest):
    response = ask_harold(payload.prompt)
    return response

    