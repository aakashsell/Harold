from google import genai
from google.genai import types
import os
from dotenv import load_dotenv
from pydantic import BaseModel, TypeAdapter


class Response(BaseModel):
  plant_name: str
  action_items: list[str]


def get_response(prompt):
    load_dotenv()

    api_key = os.getenv('GEMINI_API_KEY')

    client = genai.Client(api_key=api_key)

    response = client.models.generate_content(
        model="gemini-2.0-flash",
        contents=prompt,
        config={
            'response_mime_type': 'application/json',
            'response_schema': list[Response],
            'generate_content_config': types.GenerateContentConfig(
               tools=[types.Tool(google_search=types.GoogleSearchRetrieval)]
               )
        },    

    )

    print(response)
    return response
