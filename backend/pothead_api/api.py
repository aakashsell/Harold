from ninja import NinjaAPI
from .models import *
from .chat import *
from ninja import Schema


api = NinjaAPI()

@api.post("/add-plant")
def add_plant(owner, name, description, health):
    plant = Plant.objects.create(
        owner=owner,
        name=name,
        description=description,
        health=health
    )
    plant.save()
    return {"message": "Plant added successfully"}

@api.post("/add-user")
def add_user():
    user = User.objects.create()
    user.save()
    return {"message": user.id}

class Prompt(Schema):
    prompt: str

@api.get("/chat")
def chat(request, prompt_data: Prompt):
    response = get_response(prompt_data.prompt)
    return {"message": response}
    