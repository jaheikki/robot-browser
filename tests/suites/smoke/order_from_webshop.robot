*** Settings ***
Resource    ../../../resources/keywords/shop-keywords.resource

*** Variables ***
&{ACCOUNT_INFO}    firstName=Multi    lastName=Order    postalCode=92310000
@{PRODUCTS}    Sauce Labs Backpack    Sauce Labs Bike Light
${BASE_URL}    https://www.saucedemo.com/

*** Test Cases ***
Make Multi Product Order From Webshop
    [Documentation]    This test makes a multi product order from the webshop, verifying each step.
    # New Browser    chromium    headless=No    slowMo=0.1 #for local run with headed browser
    New Page       ${BASE_URL}
    Log In To Shop    ${BASE_URL}
    ${products_details}=    Add Products To Cart   ${PRODUCTS}
    Verify Cart Items    ${products_details}
    Make Checkout    ${BASE_URL}    ${ACCOUNT_INFO}
    Verify Order Details    ${products_details}
    Finish Order    ${BASE_URL}
    Navigate Back To Home Screen    ${BASE_URL}
    Log Out From Shop    ${BASE_URL}