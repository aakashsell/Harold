import os
from pydantic import BaseModel
from google import genai
from openai import OpenAI
import requests
from bs4 import BeautifulSoup
from pothead.models import * 

def find_product_link(product_name):
    url = f"https://www.livelyroot.com/pages/search-results-page?q={product_name.replace(' ', '+')}"
    return url

sessions = {}
sessions['last_session'] = 0

# AI Client
class AIClient:
    def __init__(self):
        self.api_key = os.getenv('GEMINI_API_KEY')
        if not self.api_key:
            raise ValueError("GEMINI_API_KEY is not set in environment variables.")
        self.client = genai.Client(api_key=self.api_key)

        self.chat = self.client.chats.create(
            model="gemini-2.0-flash",
            config={
                "system_instruction": "This is a text messaging-based context, so don't answer with complex formatting. The following conversation must be strictly about plants or gardening. If the user asks about anything else, politely remind them that this chat is only for gardening-related questions.",
                'response_mime_type': 'application/json',
                'response_schema': SimpleResponse,
            },
        )

    async def get_action_items(self, prompt: str):
        response = self.client.models.generate_content(
            model="gemini-2.0-flash",
            contents=[
                {
                    "role": "user",
                    "parts": [{"text": prompt}]
                }
            ],
            config={
                'response_mime_type': 'application/json',
                'response_schema': list[ActionResponse],
            },
        )

        parsed_response = response.parsed  # Ensure proper parsing
        if not parsed_response or not isinstance(parsed_response, list):
            raise ValueError("Invalid response format received from Gemini API.")

        return parsed_response[0].model_dump_json()

    async def talk(self, prompt: str):
        response = self.chat.send_message(prompt)

        parsed_response = response.parsed  # Ensure proper parsing
        if not parsed_response:
            raise ValueError("Invalid response format received from Gemini API.")

        return parsed_response

# Wrapper functions
async def plant_action_items(prompt_text: str):
    client = AIClient()
    return client.get_action_items(prompt_text)

def check(id):
    return id in sessions


async def ask_harold(prompt: Prompt):
    prompt_text = prompt.prompt
    if prompt.session_id not in sessions:
        return False
    client = sessions[prompt.session_id]
    answer = await client.talk(prompt_text)
    print(answer)
    for i in range(len(answer.plants_stated)):
        answer.plants_stated[i] = find_product_link(answer.plants_stated[i])
    
    for i in range(len(answer.specific_products)):
        answer.specific_products[i] = find_product_link(answer.specific_products[i])
    return answer.model_dump()

def start_session():
    client = AIClient()
    session = sessions['last_session'] + 1
    sessions['last_session'] = session
    sessions[session] = client
    return {'session_id': session}

