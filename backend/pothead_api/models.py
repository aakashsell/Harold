from django.db import models


class Plant(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField(default="No description provided")
    health = models.CharField(max_length=100, default="no health")
    owner = models.CharField(max_length=255, default="No owner provided")



class User(models.Model):
    pass

