from django.db import models


class Plant(models.Model):
    device_id = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    species = models.CharField(max_length=255)
    description = models.TextField(default="No description provided")
    health_score = models.CharField(max_length=100, default="no health")
    owner = models.CharField(max_length=255, default="No owner provided")
    created_at = models.DateTimeField(auto_now_add=False)
    plant_stage = models.CharField(max_length=255, default="seed")
    

class User(models.Model):
    ios_id = models.CharField(max_length=255)
    pass


