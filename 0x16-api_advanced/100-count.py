import praw

def count_words(subreddit, word_list, reddit=None, counts=None):
    if reddit is None:
        reddit = praw.Reddit(
            client_id='your_client_id',
            client_secret='your_client_secret',
            user_agent='your_user_agent'
        )
    if counts is None:
        counts = {}

    try:
        sub = reddit.subreddit(subreddit)
        hot_posts = sub.hot(limit=100)
    except:
        # If the subreddit is invalid, return without printing anything
        return

    for post in hot_posts:
        title_words = post.title.lower().split()
        for word in word_list:
            if word.lower() in title_words and not any(c in word for c in ['.', '!', '_']):
                counts[word.lower()] = counts.get(word.lower(), 0) + title_words.count(word.lower())

    if hot_posts:
        last_post = hot_posts[-1].created_utc
        next_posts = sub.search('', sort='new', after=last_post)
        if next_posts:
            count_words(subreddit, word_list, reddit=reddit, counts=counts)
        else:
            # Sort the counts by descending value and ascending alphabetical order
            sorted_counts = sorted(counts.items(), key=lambda x: (-x[1], x[0]))
            for word, count in sorted_counts:
                print(word, count)

