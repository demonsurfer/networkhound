from celery import Celery

from hound import hound


celery = Celery(include=['hound.tasks.rules'])
celery.conf.update(hound.config)
TaskBase = celery.Task
class ContextTask(TaskBase):
    abstract = True
    def __call__(self, *args, **kwargs):
        with hound.app_context():
            return TaskBase.__call__(self, *args, **kwargs)
celery.Task = ContextTask
