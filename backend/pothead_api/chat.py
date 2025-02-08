import openai

# Set your OpenAI API key
openai.api_key = 'your_api_key'

def get_chatgpt_response(prompt):
    response = openai.Completion.create(
        engine="text-davinci-003",
        prompt=prompt,
        max_tokens=150
    )
    return response.choices[0].text.strip()

if __name__ == "__main__":
    user_prompt = input("Enter your prompt: ")
    response = get_chatgpt_response(user_prompt)
    print("ChatGPT response:", response)