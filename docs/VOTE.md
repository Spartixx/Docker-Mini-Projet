# Vote App

## Changes explanation 
- We added the python WSGI HTTP server ``gunicorn`` to serve the app in production. It also works in dev mode.
- You can configure the workers of your app in the production environment by setting the variable ``WORKERS``.
- We removed the last two lines of the ``app.py`` file because gunicorn is starting the API from the app instance.
