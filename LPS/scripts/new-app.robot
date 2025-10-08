*** Settings ***
Documentation    Automation practice robot framework
Resource         ../../resources/QCe-site.resource
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
${lps-submit-application}     //button[@class='btn btn-primary btn-lg menu_buttons' and @onclick='open_liquor_permit_module()']
${feedback-survey}            //button[@class='swal2-confirm swal2-styled' and text()='OK']

# Can be changed to certain button service if needed (currently on BOSS-NEW)
${boss-qa-button}             //*[@id="nav_bar_list"]/a[4]/button

*** Test Cases ***
TC_001 - LPS New Application Applicant Online Process
    TC_001_TS_001 - Login Applicant
    TC_001_TS_002 - Go to Boss QA
    TC_001_TS_003 - Go to Liquor Permit Application
    TC_001_TS_004 - Apply for Application
    TC_001_TS_005 - Feedback Survey (If Shows Up)

TC_002 - Apply for Liquor Permit (New-Application)
    TC_001_TS_001 - Create "New" Application Type


*** Keywords ***
# TC_001 - QCe Public QA Site Login
TC_001_TS_001 - Login Applicant
    Maybe Select Login Iframe
    Wait Until Page Contains Element    ${email-input}    30s
    Wait Until Element Is Visible       ${email-input}    30s
    Input Text                          ${email-input}    ${public-applicant-email}
    Sleep                               1s
    Wait Until Page Contains Element    ${email-button}    30s
    Wait Until Element Is Enabled       ${email-button}    30s
    Click Element                       ${email-button}
    Sleep                               2s

TC_001_TS_002 - Go to Boss QA
    Wait Until Page Contains Element    ${password-input}    30s
    Wait Until Element Is Visible       ${password-input}    30s
    Input Text                          ${password-input}    ${public-applicant-password}
    Sleep                               1s
    Wait Until Page Contains Element    ${login-button}    30s
    Wait Until Element Is Enabled       ${login-button}    30s
    Click Element                       ${login-button}
    Sleep                               2s

TC_001_TS_003 - Go to Liquor Permit Application
    Wait Until Page Contains Element    ${boss-qa-button}    30s
    Wait Until Element Is Visible       ${boss-qa-button}    30s
    Scroll Element Into View            ${boss-qa-button}
    Mouse Over                          ${boss-qa-button}
    Sleep                               1s
    Click Element                       ${boss-qa-button}
    Sleep                               3s

TC_001_TS_004 - Apply for Application
    Wait Until Page Contains Element    ${lps-submit-application}    30s
    Wait Until Element Is Visible       ${lps-submit-application}    30s
    Scroll Element Into View            ${lps-submit-application}
    Sleep                               2s
    Execute Javascript                  document.querySelector("button[onclick='open_liquor_permit_module()']").click();
    Sleep                               3s

TC_001_TS_005 - Feedback Survey (If Shows Up)
    ${element_exists}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${feedback-survey}    5s
    IF    ${element_exists}
        Wait Until Element Is Visible       ${feedback-survey}    5s
        Sleep                               1s
        Click Element                       ${feedback-survey}
        Sleep                               2s
    ELSE
        Log    Feedback survey did not appear, continuing...
    END