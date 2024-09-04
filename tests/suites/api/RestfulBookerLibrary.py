import requests
from robot.api.deco import keyword

@keyword("Create Booking")
def create_booking(base_url, booking_data):
    response = requests.post(f"{base_url}/booking", json=booking_data)
    response.raise_for_status()  # Raise an exception for HTTP error responses
    return response.json()

@keyword("Get Booking")
def get_booking(base_url, booking_id):
    response = requests.get(f"{base_url}/booking/{booking_id}")
    response.raise_for_status()  # Raise an exception for HTTP error responses
    return response.json()
