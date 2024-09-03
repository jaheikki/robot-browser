*** Settings ***
Library     Browser
Library     String

*** Variables ***
${USERNAME}    standard_user
${PASSWORD}    secret_sauce
${SITE_TITLE}  Swag Labs

*** Keywords ***
Log In To Shop
    [Documentation]    Logs into the Sauce Demo webshop.
    [Arguments]    ${URL} 
    [Tags]    login
    Fill Text    [placeholder="Username"]    ${USERNAME}
    Fill Text    [placeholder="Password"]    ${PASSWORD}
    Click    [id="login-button"]
    Get Url    equals     ${URL}inventory.html
    Get Title    equals   ${SITE_TITLE} 


Add Products To Cart
    [Documentation]    Adds the specified products to the cart.
    [Arguments]    ${products}

    ${product_details_list}=    Create List
    FOR    ${product}    IN    @{products}
        &{product_details}=    Add Product To Cart    ${product} 
        ${product_details_list}=    Evaluate    ${product_details_list} + [${product_details}]   
    END
    RETURN    ${product_details_list}

Add Product To Cart
    [Documentation]    Adds the specified product to the cart.
    [Arguments]    ${product}
   
    ${product_text_with_hyphens}=    Replace String    ${product}    ${SPACE}    -
    ${product_as_id}=    Convert To Lowercase    ${product_text_with_hyphens}
    Click    [id=add-to-cart-${product_as_id}]
    Wait For Elements State    [id=remove-${product_as_id}]    visible 
    ${price_sub_selector}=    Set Variable    //*[@id='remove-${product_as_id}'
    ${price}=    getText    xpath=${price_sub_selector}]/..//*[@class='inventory_item_price']   
    &{product_details}=   Create Dictionary    productName=${product}    price=${price} 
    RETURN    &{product_details}

Verify Cart Items
    [Documentation]    Verifies that the items in the cart match the expected products.
    [Arguments]    ${products_details_list}

    Click    .shopping_cart_link    
    Check Product Details    ${products_details_list}    true   
    
Check Product Details
    [Documentation]    Reusable check.
    [Arguments]    ${products_details_list}    ${cart}

    FOR    ${product_details}    IN    @{products_details_list}
        ${product_text_with_hyphens}=    Replace String    ${product_details['productName']}    ${SPACE}    -
        ${product_as_id}=    Convert To Lowercase    ${product_text_with_hyphens}
        ${price_selector}=    Set Variable    //*[@class='inventory_item_name' and text()[normalize-space() = '${product_details['productName']}']]/../../..//*[@class='inventory_item_price']  
        IF    $cart == 'true'   
            Wait For Elements State    id=remove-${product_as_id}    visible
        END
        Wait For Elements State    ${priceSelector}      visible
        ${price}=    getText    ${price_selector}
        Should be equal    ${price}    ${product_details['price']}
    END

Make Checkout
    [Documentation]    Completes the checkout process.
    [Arguments]    ${URL}    ${account_info}
    Click    id=checkout
    Get Url    equals     ${URL}checkout-step-one.html
    Fill Text    [placeholder="First Name"]    ${account_info['firstName']}
    Fill Text    [placeholder="Last Name"]    ${account_info['lastName']}
    Fill Text    [placeholder="Zip/Postal Code"]    ${account_info['postalCode']}
    Click    id=continue
    Get Url    equals     ${URL}checkout-step-two.html

Verify Order Details
    [Documentation]    Verifies the order details on the checkout page.
    [Arguments]    ${products_details_list}  

    Check Product Details    ${products_details_list}    false

Finish Order
    [Documentation]    Completes the order process.
    [Arguments]    ${URL}  

    Click    id=finish
    Get Url    equals     ${URL}checkout-complete.html

Navigate Back To Home Screen
    [Documentation]    Returns to the home screen from the checkout complete page.
    [Arguments]    ${URL}  
    Click    id=back-to-products
    Get Url    equals     ${URL}inventory.html

Log Out From Shop
    [Documentation]    Logs out of the Sauce Demo webshop.
    [Arguments]    ${URL}  
    Click    id=react-burger-menu-btn
    Click    id=logout_sidebar_link
    Get Url    equals     ${URL}