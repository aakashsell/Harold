from ninja import NinjaAPI
from .models import *

api = NinjaAPI()

@api.post("/add-plant")
def add_plant(request, owner, name, description, health):
    plant = Plant.objects.create(
        owner=owner,
        name=name,
        description=description,
        health=health
    )
    plant.save()
    return {"message": "Plant added successfully"}

@api.post("/add-user")
def add_user(request):
    user = User.objects.create()
    user.save()
    return {"message": user.id}