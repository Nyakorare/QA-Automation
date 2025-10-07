*** Settings ***
Documentation                      QCe Site Automation
Library                            SeleniumLibrary
Library                            OperatingSystem
Library                            RequestsLibrary
Library                            FakerLibrary    WITH NAME    Faker

*** Variables ***
# urls
${qa_site_public}       https://qaqclb.unifysyscontrol.com/
${qa_site_admin}        https://adminqaqclb.unifysyscontrol.com/

*** Keywords ***
Load Environment
    # Loads variables from .env into process environment
    Evaluate    __import__('dotenv').load_dotenv()

Get Env
    [Arguments]    ${name}    ${default}=NOT_SET
    ${value}=    Get Environment Variable    ${name}    ${default}
    [Return]    ${value}

Set Public Applicant From Env
    # Exposes PUBLIC_APPLICANT_EMAIL and PUBLIC_APPLICANT_PASSWORD as suite vars
    ${email}=    Get Env    PUBLIC_APPLICANT_EMAIL
    ${password}=    Get Env    PUBLIC_APPLICANT_PASSWORD
    Set Suite Variable    ${public-applicant-email}    ${email}
    Set Suite Variable    ${public-applicant-password}    ${password}

Set All Creds From Env
    # Map all creds from .env to suite variables matching LPS/testing-creds.txt
    ${public_email}=    Get Env    PUBLIC_APPLICANT_EMAIL
    ${public_password}=    Get Env    PUBLIC_APPLICANT_PASSWORD
    Set Suite Variable    ${public-applicant-email}           ${public_email}
    Set Suite Variable    ${public-applicant-password}        ${public_password}

    ${blpd_head_email}=    Get Env    BLPD_HEAD_EMAIL
    ${blpd_head_password}=    Get Env    BLPD_HEAD_PASSWORD
    Set Suite Variable    ${blpd-head-email}                  ${blpd_head_email}
    Set Suite Variable    ${blpd-head-password}               ${blpd_head_password}

    ${lld_approver2_email}=    Get Env    LLD_APPROVER2_EMAIL
    ${lld_approver2_password}=    Get Env    LLD_APPROVER2_PASSWORD
    Set Suite Variable    ${lld-approver2-email}              ${lld_approver2_email}
    Set Suite Variable    ${lld-approver2-password}           ${lld_approver2_password}

    ${lld_assessor_email}=    Get Env    LLD_ASSESSOR_EMAIL
    ${lld_assessor_password}=    Get Env    LLD_ASSESSOR_PASSWORD
    Set Suite Variable    ${lld-assessor-email}               ${lld_assessor_email}
    Set Suite Variable    ${lld-assessor-password}            ${lld_assessor_password}

    ${lld_chief_email}=    Get Env    LLD_CHIEF_EMAIL
    ${lld_chief_password}=    Get Env    LLD_CHIEF_PASSWORD
    Set Suite Variable    ${lld-chief-email}                  ${lld_chief_email}
    Set Suite Variable    ${lld-chief-password}               ${lld_chief_password}

    ${lld_evaluator_email}=    Get Env    LLD_EVALUATOR_EMAIL
    ${lld_evaluator_password}=    Get Env    LLD_EVALUATOR_PASSWORD
    Set Suite Variable    ${lld-evaluator-email}              ${lld_evaluator_email}
    Set Suite Variable    ${lld-evaluator-password}           ${lld_evaluator_password}

    ${lld_initial_approver_email}=    Get Env    LLD_INITIAL_APPROVER_EMAIL
    ${lld_initial_approver_password}=    Get Env    LLD_INITIAL_APPROVER_PASSWORD
    Set Suite Variable    ${lld-initial-approver-email}       ${lld_initial_approver_email}
    Set Suite Variable    ${lld-initial-approver-password}    ${lld_initial_approver_password}

    ${lld_occular_email}=    Get Env    LLD_OCCULAR_EMAIL
    ${lld_occular_password}=    Get Env    LLD_OCCULAR_PASSWORD
    Set Suite Variable    ${lld-occular-email}                ${lld_occular_email}
    Set Suite Variable    ${lld-occular-password}             ${lld_occular_password}

    ${lld_printing_email}=    Get Env    LLD_PRINTING_EMAIL
    ${lld_printing_password}=    Get Env    LLD_PRINTING_PASSWORD
    Set Suite Variable    ${lld-printing-email}               ${lld_printing_email}
    Set Suite Variable    ${lld-printing-password}            ${lld_printing_password}

    ${lld_releasing_email}=    Get Env    LLD_RELEASING_EMAIL
    ${lld_releasing_password}=    Get Env    LLD_RELEASING_PASSWORD
    Set Suite Variable    ${lld-releasing-email}              ${lld_releasing_email}
    Set Suite Variable    ${lld-releasing-password}           ${lld_releasing_password}

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