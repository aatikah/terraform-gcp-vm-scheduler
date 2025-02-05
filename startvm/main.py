import google.auth
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError


def start_my_vm(request):
    project_id = "tikah-449818"
    zone = "us-central1-c"
    instance_name = "tikahvm"
    
    credentials, _ = google.auth.default()
    service = build('compute', 'v1', credentials=credentials)

    try:
        request = service.instances().start(project=project_id, zone=zone, instance=instance_name)
        response = request.execute()
        return 'VM started successfully', 200
    except HttpError as err:
        return 'Error: {}'.format(err), 500