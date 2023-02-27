import requests

def top_ten(subreddit):
    # Make the API request
    url = f"https://www.reddit.com/r/{subreddit}/hot.json?limit=10"
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, headers=headers, allow_redirects=False)
    
    # Check if the subreddit is valid
    if response.status_code == 200:
        # Parse the JSON response
        data = response.json()
        
        # Print the titles of the first 10 hot posts
        for i in range(10):
            print(data["data"]["children"][i]["data"]["title"])
    else:
        print(None)

