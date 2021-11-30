from controller.pipelines import factory, run
from controller.tasks import create_tasks

def main(request) -> dict:
    data = request.get_json()
    print(data)

    if "task" in data:
        response = create_tasks()
    elif "table" in data:
        response = run(factory(data["table"]))
    else:
        raise ValueError(data)

    print(response)
    return response
