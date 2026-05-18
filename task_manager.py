"""Simple task management helpers used in the Git Flow practice exercise."""


def create_task(title, description):
    """Create a task payload and print a confirmation message."""
    task = {
        "title": title,
        "description": description,
        "status": "new",
    }
    print(f"Created a new task: {title}")
    return task
