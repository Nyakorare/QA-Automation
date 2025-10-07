*** Settings ***
Documentation                      QCe Site Automation
Library                            SeleniumLibrary
Library                            OperatingSystem
Library                            RequestsLibrary
Library                            FakerLibrary    WITH NAME    Faker
Resource                           env.resource

*** Variables ***
# urls
${qa_site_public}       https://qaqclb.unifysyscontrol.com/
${qa_site_admin}        https://adminqaqclb.unifysyscontrol.com/

*** Keywords ***
Open QA Browser
    Open Browser                  ${qa_site_public}   Chrome
    Maximize Browser Window

Open Admin QA Browser
    Open Browser                  ${qa_site_admin}    Chrome
    Maximize Browser Window

# For Sure Checking
Maybe Select Login Iframe 
    ${has_iframe}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//iframe[contains(@src,'login') or contains(@id,'login') or contains(@name,'login')]
    Run Keyword If    ${has_iframe}    Select Frame    xpath=//iframe[contains(@src,'login') or contains(@id,'login') or contains(@name,'login')]