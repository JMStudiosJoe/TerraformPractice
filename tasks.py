from celery import Celery

app = Celery('tasks', broker='redis://localhost:6300')


@app.task
def add(x, y):
    return x + y
