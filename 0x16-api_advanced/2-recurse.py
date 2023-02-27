import requests
import time

def recurse(subreddit, hot_list=[]):
    headers = {'User-Agent': 'myBot/0.0.1'}
    url = f'https://www.reddit.com/r/{subreddit}/hot.json'
    response = requests.get(url, headers=headers)
    
    if response.status_code != 200:
        return None
    
    data = response.json()['data']
    articles = data['children']
    for article in articles:
        hot_list.append(article['data']['title'])
    
    after = data['after']
    if after:
        time.sleep(2)  # Sleep to avoid hitting Reddit's API too frequently
        recurse(subreddit, hot_list=hot_list, after=after)
    else:
        return hot_list

