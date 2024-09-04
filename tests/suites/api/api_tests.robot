*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    ../../../libraries/RestfulBookerLibrary.py

*** Variables ***
${BASE_URL}    https://restful-booker.herokuapp.com 

*** Test Cases ***
Create a Booking at Restful Booker With Robot
    ${booking_dates}    Create Dictionary    checkin=2022-12-31    checkout=2023-01-01
    ${booking_data}    Create Dictionary    firstname=Hans    lastname=Gruber    totalprice=200    depositpaid=false    bookingdates=${booking_dates}
    ${response}    POST    url=${BASE_URL}/booking    json=${booking_data}
    ${id}    Set Variable    ${response.json()}[bookingid]
    Set Suite Variable    ${id}
    ${response}    GET    ${BASE_URL}/booking/${id}
    Should Be Equal    ${response.json()}[lastname]    Gruber
    Should Be Equal    ${response.json()}[firstname]    Hans   
    Should Be Equal As Numbers    ${response.json()}[totalprice]    200
    Dictionary Should Contain Value     ${response.json()}    Gruber

Create a Booking at Restful Booker With Python
    ${booking_data}    Create Dictionary
    ...    firstname=Jack
    ...    lastname=Gruber
    ...    totalprice=300
    ...    depositpaid=false
    ${booking_dates}    Create Dictionary    checkin=2022-12-31    checkout=2023-01-01
    Set To Dictionary    ${booking_data}    bookingdates=${booking_dates}
    ${response}    Create Booking    ${BASE_URL}    ${booking_data}
    ${id}    Set Variable    ${response['bookingid']}
    Set Suite Variable    ${id}
    ${response}    Get Booking    ${BASE_URL}    ${id}
    Should Be Equal    ${response['lastname']}    Gruber
    Should Be Equal    ${response['firstname']}    Jack
    Should Be Equal As Numbers    ${response['totalprice']}    300
    Dictionary Should Contain Value    ${response}    Gruber