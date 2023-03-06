To complete this task, follow these steps:

Ensure that task #3 of your SSH project is completed for web-01.

SSH into your web-01 server and clone your AirBnB_clone_v2 repository:
git clone https://github.com/your_username/AirBnB_clone_v2.git
Change into the AirBnB_clone_v2 directory:


cd AirBnB_clone_v2/
Open the file web_flask/0-hello_route.py in your preferred text editor and modify it as follows:

python

from flask import Flask

app = Flask(__name__)


@app.route('/airbnb-onepage/', strict_slashes=False)
def hello():
    return "Hello HBNB!"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
Here, we've added a route decorator to the app object that will respond to requests to the /airbnb-onepage/ URL path. We've also set the Flask app's name to app, as required.

Save and close the file.

Run the Flask app by executing the following command:

python3 -m web_flask.0-hello_route
This will start the Flask development server, listening on port 5000.

In your web browser, navigate to http://web-01.your_domain_name.com:5000/airbnb-onepage/. You should see the message "Hello HBNB!" displayed in your browser.

Press Ctrl+C to stop the Flask development server.

Commit your changes to your Git repository and push them to GitHub.

git add web_flask/0-hello_route.py
git commit -m "Configure Flask app to serve content from /airbnb-onepage/"
git push origin master
