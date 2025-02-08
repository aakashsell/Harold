from ninja import NinjaAPI, Schema
from pydantic import BaseModel
from .models import *
from .chat import *
from django.http import JsonResponse



api = NinjaAPI()

@api.post("/add-plant/")
def add_plant(request, payload: Plant):
    plant = Plant.objects.create(
        device_id=payload.device_id,
        name=payload.name,
        species=payload.species,
        description=payload.description,
        health_score=payload.health_score,
        owner=payload.owner,
        created_at=payload.created_at,
        plant_stage=payload.plant_stage
    )
    plant.save()
    return {"message": "Plant added successfully"}

@api.post("/add-user/")
def add_user(request, ios_id):
    user = User.objects.create(
        ios_id=ios_id
    )
    user.save()
    return user




class ChatRequest(Schema):
    prompt: str

@api.post("/plant-health/")
def plant_health(request, plant_id, device_id):
    plant = Plant.objects.get(id=plant_id, device_id=device_id)
    species = plant.species
    health = plant.health_score
    stage = plant.plant_stage
    prompt = f"""My plant is a {species} and its health is currently at {health}%.
    it is in the stage of {stage}. Please give verbose and personable action items to help my plant thrive."""
    response = plant_action_itmes(prompt)
    return response

@api.post("/chat/")
def chat(request, payload: ChatRequest):
    response = ask_harold(payload.prompt)
    return response

    