# pip install requests
import requests

URL = "http://localhost:8080/v1/chat/completions"

messages = [{"role": "system", "content": "Du bist ein hilfreicher Assistent."}]

print("Chat mit llama.cpp (beenden mit 'exit')")
while True:
    user_input = input("Du: ").strip()
    if user_input.lower() in ("exit", "quit"):
        break

    messages.append({"role": "user", "content": user_input})

    response = requests.post(URL, json={
        "messages": messages,
        "temperature": 0.7,
        "max_tokens": 512,
    })
    response.raise_for_status()

    answer = response.json()["choices"][0]["message"]["content"]
    messages.append({"role": "assistant", "content": answer})
    print(f"KI: {answer}\n")
