*** Settings ***
Documentation    Automation practice robot framework
Resource         ../../global-resources/QCe-site.resource
Resource         local-functions.resource
Suite Setup      Run Keywords    Load Environment    AND    Set All Creds From Env
Test Setup       Open QA Browser
Library          SeleniumLibrary
Library          FakerLibrary
Library          Dialogs
Test Teardown    Close Browser

*** Variables ***
#account input fields
${email-input}                id=input_username
${email-button}               id=btn-continue
${password-input}             id=input_password
${login-button}               id=login-btn
${lps-submit-application}     xpath=//button[@class='btn btn-primary btn-lg menu_buttons' and @onclick='open_liquor_permit_module()']
${apply-for-application}      xpath=//*[@id="page-content-wrapper"]/div/div/div/div[2]/button
${new-application-type}       id=apply_new
${proceed-to-next}            id=req-continue
${mayors-permit-input}        id=mp_number
${proceed-mp}                 xpath=/html/body/div[3]/div/div[24]/div/div/form/div/div[3]/div/button[2]
${next-continue-details}      id=btn-continue2
${next-continue-details2}     xpath=//button[@id='btn-continue2' and not(ancestor::div[contains(@style,'display: none')])]
${next-continue-details3}     xpath=/html/body/div[3]/div/div[2]/div/div/div/form/div/div[2]/div[2]/div/div/div[4]/div/div/div[3]/div[2]/button[2]

# "New" Application Type Button
${boss-qa-button}             xpath=//*[@id="nav_bar_list"]/a[4]/button

# Mayor's Permit Number
${mayors-permit-number-new}   25-990125    # 19-002724

*** Test Cases ***
TC_001 - LPS Module Process
    TC_001_TS_001 - Login Applicant
    TC_001_TS_002 - Go to Boss QA
    TC_001_TS_003 - Go to Liquor Permit Application
    TC_001_TS_004 - Apply for Application
    TC_001_TS_005 - Feedback Survey (If Shows Up)
    TC_001_TS_006 - Create "New" Application Type
    ${can_continue}=    TC_001_TS_007 - Mayor's Permit Number Confirmation
    IF    ${can_continue}
        TC_001_TS_008 - Complete New Application Form
    ELSE
        Log To Console    Process ended due to Mayor Permit Number error/in use - not continuing to TC_001_TS_008
    END

*** Keywords ***

# TC_001 - LPS Module Process
TC_001_TS_001 - Login Applicant
    Log To Console                   START: TC_001_TS_001 - Login Applicant
    Maybe Select Login Iframe
    Wait Until Page Contains Element    ${email-input}    30s
    Wait Until Element Is Visible       ${email-input}    30s
    Input Text                          ${email-input}    ${public-applicant-email}
    Sleep                               1s
    Wait Until Page Contains Element    ${email-button}    30s
    Wait Until Element Is Enabled       ${email-button}    30s
    Click Element                       ${email-button}
    Sleep                               2s
    Log To Console                   END: TC_001_TS_001 - Login Applicant

TC_001_TS_002 - Go to Boss QA
    Log To Console                   START: TC_001_TS_002 - Go to Boss QA
    Wait Until Page Contains Element    ${password-input}    30s
    Wait Until Element Is Visible       ${password-input}    30s
    Input Text                          ${password-input}    ${public-applicant-password}
    Sleep                               1s
    Wait Until Page Contains Element    ${login-button}    30s
    Wait Until Element Is Enabled       ${login-button}    30s
    Click Element                       ${login-button}
    Sleep                               2s
    Log To Console                   END: TC_001_TS_002 - Go to Boss QA

TC_001_TS_003 - Go to Liquor Permit Application
    Log To Console                   START: TC_001_TS_003 - Go to Liquor Permit Application
    Wait Until Page Contains Element    ${boss-qa-button}    30s
    Wait Until Element Is Visible       ${boss-qa-button}    30s
    Scroll Element Into View            ${boss-qa-button}
    Mouse Over                          ${boss-qa-button}
    Click Element                       ${boss-qa-button}
    Sleep                               2s
    Log To Console                   END: TC_001_TS_003 - Go to Liquor Permit Application

TC_001_TS_004 - Apply for Application
    Log To Console                   START: TC_001_TS_004 - Apply for Application
    Wait Until Page Contains Element    ${lps-submit-application}    30s
    Wait Until Element Is Visible       ${lps-submit-application}    30s
    Scroll Element Into View            ${lps-submit-application}
    Sleep                               1s
    Execute Javascript                  document.querySelector("button[onclick='open_liquor_permit_module()']").click();
    Sleep                               3s
    Log To Console                   END: TC_001_TS_004 - Apply for Application

TC_001_TS_005 - Feedback Survey (If Shows Up)
    Log To Console                   START: TC_001_TS_005 - Feedback Survey
    Handle Feedback Survey
    Log To Console                   END: TC_001_TS_005 - Feedback Survey

TC_001_TS_006 - Create "New" Application Type
    Log To Console                   START: TC_001_TS_006 - Create "New" Application Type
    Wait Until Page Contains Element    ${apply-for-application}    30s
    Wait Until Element Is Visible       ${apply-for-application}    30s
    Click Element                       ${apply-for-application}
    Sleep                               1s
    Wait Until Page Contains Element    ${new-application-type}    30s
    Wait Until Element Is Visible       ${new-application-type}    30s
    Click Element                       ${new-application-type}
    Sleep                               1s
    Wait Until Page Contains Element    ${proceed-to-next}    30s
    Wait Until Element Is Visible       ${proceed-to-next}    30s
    Click Element                       ${proceed-to-next}
    Sleep                               2s
    Input Text                          ${mayors-permit-input}    ${mayors-permit-number-new}
    Log To Console                   END: TC_001_TS_006 - Create "New" Application Type
    
TC_001_TS_007 - Mayor's Permit Number Confirmation
    Log To Console                   START: TC_001_TS_007 - Mayor's Permit Number Confirmation
    Click Element                       ${proceed-mp}
    Sleep                               1s
    ${can_continue}=    Handle Mayor Permit Number Confirmation
    Sleep                               2s
    Log To Console                   END: TC_001_TS_007 - Mayor's Permit Number Confirmation
    RETURN    ${can_continue}

TC_001_TS_008 - Complete New Application Form
    Log To Console                   START: TC_001_TS_008 - Complete New Application Form
    
    # Step 1: Business Type Selection (1st Page)
    Log To Console                   Step 1: Selecting Business Type Checkboxes
    Randomly Select Business Type Checkboxes
    Robust Click                        ${next-continue-details}
    Sleep                               2s
    Log To Console                   Step 1: Completed Business Type Selection
    
    # Step 2: Liquor Permit Selection (2nd Page)
    Log To Console                   Step 2: Selecting Liquor Permit Checkboxes
    Randomly Select Liquor Permit Checkboxes
    Sleep                               2s
    Click First Visible                 ${next-continue-details2}
    Sleep                               2s
    Log To Console                   Step 2: Completed Liquor Permit Selection
    
    # Step 3: File Uploads (3rd Page)
    Log To Console                   Step 3: Handling File Uploads
    Handle File Uploads
    Sleep                               2s
    # Use filtered visible continue button (Step 4 is similar to Step 2 visibility handling)
    Click First Visible                 ${next-continue-details2}
    Log To Console                   Step 3: Completed File Uploads
    Log To Console                   END: TC_001_TS_008 - Complete New Application Form

    #Step 4: Applied By
    Log To Console                   Step 4: Applied By
    Randomly Select Applied By
    Sleep                               2s
    Click First Visible                 ${next-continue-details3}
    Log To Console                   Step 4: Completed Applied By