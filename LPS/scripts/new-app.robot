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
${login-button}               id=login-btn

*** Test Cases ***
TC_001 - LPS New Application Applicant Online Process
    TC_001_TS_001 - Login Applicant

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
    Click Button                        ${email-button}
    Sleep                               3s