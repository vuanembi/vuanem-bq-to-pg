from controller.pipelines import factory, run


def main(request) -> dict:
    data = request.get_json()
    print(data)

    # if "tasks" in data:
    #     results = orchestrate(data['tasks'])
    if "table" in data:
        results = run(factory(data["table"]))
    else:
        raise ValueError(data)

    response = {
        "pipelines": "BQ-PG",
        "results": results,
    }
    print(response)
    return response
