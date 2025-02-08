import os
from dotenv import load_dotenv
from pydantic import BaseModel
from google import genai

class Response(BaseModel):
    plant_name: str
    action_items: list[str]

class AIClient:
    def __init__(self):
        load_dotenv()
        self.api_key = os.getenv('GEMINI_API_KEY')
        self.client = genai.Client(api_key=self.api_key)

    def generate_content(self, prompt):
        response = self.client.models.generate_content(
            model="gemini-2.0-flash",
            contents=prompt,
            config={
                'response_mime_type': 'application/json',
                'response_schema': list[Response],
            },
        )
        parsed_response: Response = response.parsed
        return parsed_response[0].model_dump_json()

def get_response(prompt_text):
    client = AIClient()
    return client.generate_content(prompt_text)
