import os
from dotenv import load_dotenv
from pydantic import BaseModel
from google import genai

class ActionResponse(BaseModel):
    plant_name: str
    prompt: str
    action_items: list[str]

class SimpleResponse(BaseModel):
    prompt: str
    response: str

class AIClient:
    def __init__(self):
        load_dotenv()
        self.api_key = os.getenv('GEMINI_API_KEY')
        self.client = genai.Client(api_key=self.api_key)

    def get_action_items(self, prompt):
        response = self.client.models.generate_content(
            model="gemini-2.0-flash",
            contents=prompt,
            config={
                'response_mime_type': 'application/json',
                'response_schema': list[ActionResponse],
            },
        )
        parsed_response: ActionResponse = response.parsed
        return parsed_response[0].model_dump_json()
    
    def talk(self, prompt):
        response = self.client.models.generate_content(
            model="gemini-2.0-flash",
            contents=["the following question is about plants or gardening, please answer accordingly", prompt],
            config={
                'response_mime_type': 'application/json',
                'response_schema': SimpleResponse,
            },
        )
        parsed_response: SimpleResponse = response.parsed
        return parsed_response.model_dump_json()


def plant_action_itmes(prompt_text):
    client = AIClient()
    return client.get_action_items(prompt_text)

def ask_harold(prompt_text):
    client = AIClient()
    answer = client.talk(prompt_text)
    print(answer)
    return answer

