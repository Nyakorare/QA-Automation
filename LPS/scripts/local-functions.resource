*** Settings ***
Documentation    Local functions for LPS automation
Library          SeleniumLibrary
Library          Collections

*** Variables ***
# Business Information checkboxes
${bi-wholesaler}              id=chkWholesaler
${bi-retailer}                id=chkRetailer
${bi-server_dispenser}        id=chkServerDispenser
${manufacturer}               id=chkManufacturer
${bi-amusements}              id=chkAmusements
${first-page-continue}        id=btn-continue2

# Feedback survey elements
${feedback-survey}            xpath=//button[@class='swal2-confirm swal2-styled' and text()='OK']

# Mayor's permit elements
${error-creation-modal}       xpath=/html/body/div[9]/div/div[3]/button[1]
${mp-next}                    id=mp-continue

*** Keywords ***
Randomly Select Business Type Checkboxes
    # List of all available checkbox IDs
    @{checkbox_list}=    Create List    ${bi-wholesaler}    ${bi-retailer}    ${bi-server_dispenser}    ${manufacturer}    ${bi-amusements}
    
    # Generate random number of checkboxes to select (1-4)
    ${num_to_select}=    Evaluate    random.randint(1, 4)    modules=random
    
    # Shuffle the list to randomize selection order
    ${shuffled_list}=    Evaluate    random.sample($checkbox_list, $num_to_select)    modules=random
    
    Log To Console    Selecting ${num_to_select} random checkboxes from available options
    
    # Click each selected checkbox
    FOR    ${checkbox}    IN    @{shuffled_list}
        Wait Until Element Is Visible    ${checkbox}    10s
        Click Element    ${checkbox}
        Sleep    0.5s
        Log To Console    Selected checkbox: ${checkbox}
    END
    
    Log To Console    Completed random checkbox selection

Handle Feedback Survey
    ${element_exists}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${feedback-survey}    5s
    IF    ${element_exists}
        Log To Console    Feedback appeared, continuing...
        Wait Until Element Is Visible       ${feedback-survey}    5s
        Sleep                               1s
        Click Element                       ${feedback-survey}
        Sleep                               2s
    ELSE
        Log To Console    Feedback survey did not appear, continuing...
    END
    
Handle Mayor Permit Number Confirmation
    ${element_exists}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${error-creation-modal}    5s
    IF    ${element_exists}
        Log To Console    Mayor Permit Number already in use/ Not Found, ending process...
        Log To Console    Did not create a new application type because it is already in use/ Not Found.
        Wait Until Element Is Visible       ${error-creation-modal}    5s
        Click Element                       ${error-creation-modal}
        RETURN    ${False}
    ELSE
        Log To Console    Mayor Permit Number Confirmed & Working, continuing...
        Wait Until Element Is Visible       ${mp-next}    5s
        Click Element                       ${mp-next}
        RETURN    ${True}
    END
