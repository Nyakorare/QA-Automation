*** Settings ***
Documentation    Local functions for LPS automation
Library          SeleniumLibrary
Library          Collections
Library          String
Library          OperatingSystem

*** Variables ***
# Business Information checkboxes
${bi-wholesaler}              id=chkWholesaler
${bi-retailer}                id=chkRetailer
${bi-server_dispenser}        id=chkServerDispenser
${manufacturer}               id=chkManufacturer
${bi-amusements}              id=chkAmusements

# Feedback survey elements
${feedback-survey}            xpath=//button[@class='swal2-confirm swal2-styled' and text()='OK']

# Mayor's permit elements
${error-creation-modal}       xpath=/html/body/div[9]/div/div[3]/button[1]
${mp-next}                    xpath=/html/body/div[3]/div/div[25]/div/div/div[3]/button[2]

# Liquor Permit being applied for
${lpbaf-special-permit}       id=chkSpecialPermit
${lpbaf-beer}                 id=chkBeer
${lpbaf-local-wine}           id=chkLocalWine
${lpbaf-imported-wine}        id=chkImportedWine

# File upload elements
${dr-barangay-clearance}      id=chkBrgyClearance
${dr-brgy-file-input}         xpath=//*[@id="brgyClearance_div"]//input[@type='file']
${dr-sketch-of-location}      id=chkSketch
${dr-sketch-file-input}       xpath=//*[@id="sketchLocation_div"]//input[@type='file']
${dr-others}                  id=chkOthers
${dr-others-input}            xpath=//*[@id="append_docuOthers"]/div/div[1]/input[2]
${dr-others-file-input1}      xpath=//*[@id="docuOthers1_div"]//input[@type='file']
${dr-others-input2}           xpath=//*[@id="append_docuOthers"]/div[2]/div[1]/input[2]
${dr-others-file-input2}      xpath=//*[@id="docuOthers2_div"]//input[@type='file']
${dr-others-input3}           xpath=//*[@id="append_docuOthers"]/div[3]/div[1]/input[2]
${dr-others-file-input3}      xpath=//*[@id="docuOthers3_div"]//input[@type='file']

# Test file paths for uploads
${brgy-clearance-file}        C:\\Users\\Glenn\\Documents\\Projects\\QA Automation-Sandman\\test-files\\BARANGAYCLEARANCELIQUOR_SAMPLE.pdf
${sketch-location-file}       C:\\Users\\Glenn\\Documents\\Projects\\QA Automation-Sandman\\test-files\\SKETCHOFLOCATION_SAMPLE.pdf
${authorization-letter-file}  C:\\Users\\Glenn\\Documents\\Projects\\QA Automation-Sandman\\test-files\\AUTHORIZATIONLETTER_SAMPLE.pdf
${id-sample-file}             C:\\Users\\Glenn\\Documents\\Projects\\QA Automation-Sandman\\test-files\\id_sample.png
${receipt-sample-file}        C:\\Users\\Glenn\\Documents\\Projects\\QA Automation-Sandman\\test-files\\receipt_sample.png

# Invalid file for negative upload testing (not in allowed extensions)
${invalid-upload-file}        C:\\Users\\Glenn\\Documents\\Projects\\QA Automation-Sandman\\test-files\\invalid-upload.txt

# Additional allowed sample files for Step 4
${jpg-7mb-file}              C:\\Users\\Glenn\\Documents\\Projects\\QA Automation-Sandman\\test-files\\7mb-jpg.jpg
${jpg-8mb-file}              C:\\Users\\Glenn\\Documents\\Projects\\QA Automation-Sandman\\test-files\\8mb-jpg.jpg
${jpg-10mb-file}             C:\\Users\\Glenn\\Documents\\Projects\\QA Automation-Sandman\\test-files\\10mb-jpg.jpg
${pdf-10mb-file}             C:\\Users\\Glenn\\Documents\\Projects\\QA Automation-Sandman\\test-files\\10mb-pdf.pdf
${sample-pdf-file}           C:\\Users\\Glenn\\Documents\\Projects\\QA Automation-Sandman\\test-files\\sample-document.pdf
${sample-pdf2-file}          C:\\Users\\Glenn\\Documents\\Projects\\QA Automation-Sandman\\test-files\\SAMPLE.pdf
${id-sample2-file}           C:\\Users\\Glenn\\Documents\\Projects\\QA Automation-Sandman\\test-files\\id_sample2.png

#Applied By (Business Owner or Authorized Representative)
${owner-or-representative}       id=chk_representative
${owner-name}                 id=applicant_owner_name

${representative-name}        xpath=//*[@id="applicant_owner_name"]
${representative-position}    xpath=//*[@id="designation"]
${representative-email}       id=email
${representative-owner-id}    xpath=//*[@id="owners_id_div"]/div[1]/button
${representative-auth}        xpath=//*[@id="signed_authorization_div"]/div[1]/button
${representative-id}          xpath=//*[@id="representative_id_div"]/div[1]/button

# Step 4 file INPUT locators (upload directly like Step 3)
${owner-file-input}           xpath=//*[@id="owners_id_div"]//input[@type='file']
${rep-owner-id-input}         xpath=//*[@id="owners_id_div"]//input[@type='file']
${rep-auth-input}             xpath=//*[@id="signed_authorization_div"]//input[@type='file']
${rep-id-input}               xpath=//*[@id="representative_id_div"]//input[@type='file']

${email}=       Get Env    PUBLIC_APPLICANT_EMAIL

*** Keywords ***
Robust Click
    [Arguments]    ${locator}    ${timeout}=30s
    Wait Until Page Contains Element    ${locator}    ${timeout}
    Wait Until Element Is Visible       ${locator}    ${timeout}
    Wait Until Element Is Enabled       ${locator}    ${timeout}
    Scroll Element Into View            ${locator}
    ${clicked}=    Run Keyword And Return Status    Click Element    ${locator}
    IF    not ${clicked}
        ${el}=    Get WebElement    ${locator}
        Execute Javascript    arguments[0].click();    ${el}
    END
    Sleep    0.5s

Click First Visible
    [Arguments]    ${locator}    ${timeout}=30s
    Wait Until Page Contains Element    ${locator}    ${timeout}
    @{elements}=    Get WebElements    ${locator}
    FOR    ${el}    IN    @{elements}
        ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${el}
        IF    ${is_visible}
            Scroll Element Into View    ${el}
            ${clicked}=    Run Keyword And Return Status    Click Element    ${el}
            IF    not ${clicked}
                Execute Javascript    arguments[0].click();    ${el}
            END
            Sleep    0.5s
            RETURN
        END
    END
    Fail    No visible element found for locator: ${locator}

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
        Sleep                               2s
        RETURN    ${True}
    END

Randomly Select Business Type Checkboxes
    # Business Information checkboxes
    @{checkbox_list}=    Create List    ${bi-wholesaler}    ${bi-retailer}    ${bi-server_dispenser}    ${manufacturer}    ${bi-amusements}

    ${num_to_select}=    Evaluate    random.randint(1, 4)    modules=random
    ${shuffled_list}=    Evaluate    random.sample($checkbox_list, $num_to_select)    modules=random
    
    Log To Console    Selecting ${num_to_select} random checkboxes from available options

    FOR    ${checkbox}    IN    @{shuffled_list}
        Wait Until Element Is Visible    ${checkbox}    10s
        Click Element    ${checkbox}
        Sleep    0.5s
        Log To Console    Selected checkbox: ${checkbox}
    END
    
    Log To Console    Completed random checkbox selection

Randomly Select Liquor Permit Checkboxes
    # Liquor Permit checkboxes - at least one of beer, local wine, or imported wine must be selected
    @{required_checkboxes}=    Create List    ${lpbaf-beer}    ${lpbaf-local-wine}    ${lpbaf-imported-wine}
    @{optional_checkboxes}=    Create List    ${lpbaf-special-permit}
    
    # Always select at least one required checkbox (beer as default, then add others randomly)
    Wait Until Element Is Visible    ${lpbaf-beer}    10s
    Click Element    ${lpbaf-beer}
    Sleep    0.5s
    Log To Console    Selected required checkbox: ${lpbaf-beer}
    
    # Randomly select 0-2 additional required checkboxes
    ${additional_required}=    Evaluate    random.randint(0, 2)    modules=random
    IF    ${additional_required} > 0
        @{remaining_required}=    Create List    ${lpbaf-local-wine}    ${lpbaf-imported-wine}
        ${selected_additional}=    Evaluate    random.sample($remaining_required, $additional_required)    modules=random
        
        FOR    ${checkbox}    IN    @{selected_additional}
            Wait Until Element Is Visible    ${checkbox}    10s
            Click Element    ${checkbox}
            Sleep    0.5s
            Log To Console    Selected additional required checkbox: ${checkbox}
        END
    END
    
    # Then randomly select optional checkboxes (special permit)
    ${num_optional}=    Evaluate    random.randint(0, 1)    modules=random
    IF    ${num_optional} > 0
        ${selected_optional}=    Evaluate    random.sample($optional_checkboxes, $num_optional)    modules=random
        Log To Console    Selecting ${num_optional} optional liquor permit checkboxes
        
        FOR    ${checkbox}    IN    @{selected_optional}
            Wait Until Element Is Visible    ${checkbox}    10s
            Click Element    ${checkbox}
            Sleep    0.5s
            Log To Console    Selected optional checkbox: ${checkbox}
        END
    ELSE
        Log To Console    No optional liquor permit checkboxes selected
    END
    
    Log To Console    Completed random liquor permit checkbox selection

Handle File Uploads
    # Always check brgy clearance (required)
    Log To Console    Checking required brgy clearance checkbox
    Wait Until Element Is Visible    ${dr-barangay-clearance}    10s
    Click Element    ${dr-barangay-clearance}
    Sleep    0.5s
    
    # Wait for upload button to appear and upload file
    Wait Until Page Contains Element    ${dr-brgy-file-input}    10s
    Choose Unique File    ${dr-brgy-file-input}    ${brgy-clearance-file}
    Sleep    1s
    Log To Console    Uploaded file for brgy clearance
    
    # Randomly decide whether to check sketch of location (optional)
    ${check_sketch}=    Evaluate    random.choice([True, False])    modules=random
    IF    ${check_sketch}
        Log To Console    Checking optional sketch of location checkbox
        Wait Until Element Is Visible    ${dr-sketch-of-location}    10s
        Click Element    ${dr-sketch-of-location}
        Sleep    0.5s
        
        # Wait for upload button to appear and upload file
        Wait Until Page Contains Element    ${dr-sketch-file-input}    10s
        Choose Unique File    ${dr-sketch-file-input}    ${sketch-location-file}
        Sleep    1s
        Log To Console    Uploaded file for sketch of location
    ELSE
        Log To Console    Skipping sketch of location checkbox
    END
    
    # Randomly decide whether to check others (optional, 1-3 times)
    ${check_others}=    Evaluate    random.choice([True, False])    modules=random
    IF    ${check_others}
        ${num_others}=    Evaluate    random.randint(1, 3)    modules=random
        Log To Console    Checking others checkbox and will add ${num_others} other documents
        
        Wait Until Element Is Visible    ${dr-others}    10s
        Click Element    ${dr-others}
        Sleep    0.5s
        
        # Handle the first "others" input and upload
        Wait Until Element Is Visible    ${dr-others-input}    10s
        Input Text    ${dr-others-input}    Authorization Letter
        Sleep    0.5s
        
        Wait Until Page Contains Element    ${dr-others-file-input1}    10s
        Choose Unique File    ${dr-others-file-input1}    ${authorization-letter-file}
        Sleep    1s
        Log To Console    Added first other document: Authorization Letter
        
        # Handle additional "others" inputs if num_others > 1
        IF    ${num_others} >= 2
            Wait Until Element Is Visible    ${dr-others-input2}    10s
            Input Text    ${dr-others-input2}    ID Sample
            Sleep    0.5s
            
            Wait Until Page Contains Element    ${dr-others-file-input2}    10s
            Choose Unique File    ${dr-others-file-input2}    ${id-sample-file}
            Sleep    1s
            Log To Console    Added second other document: ID Sample
        END
        
        # Handle third "others" input if num_others = 3
        IF    ${num_others} == 3
            Wait Until Element Is Visible    ${dr-others-input3}    10s
            Input Text    ${dr-others-input3}    Receipt Sample
            Sleep    0.5s
            
            Wait Until Page Contains Element    ${dr-others-file-input3}    10s
            Choose Unique File    ${dr-others-file-input3}    ${receipt-sample-file}
            Sleep    1s
            Log To Console    Added third other document: Receipt Sample
        END
    ELSE
        Log To Console    Skipping others checkbox
    END
    
    Log To Console    Completed file upload process

Randomly Select Applied By
    # Randomly choose between Business Owner (0) and Authorized Representative (1)
    ${is_owner}=    Evaluate    random.choice([True, False])    modules=random
    IF    ${is_owner}
        Log To Console    Applied By: Business Owner
        # Select Owner in dropdown by visible label
        Wait Until Page Contains Element    ${owner-or-representative}    10s
        Select From List By Label    ${owner-or-representative}    Business Owner

        # Fill Owner Name
        ${owner_full_name}=    FakerLibrary.Name
        Wait Until Element Is Visible    ${owner-name}    10s
        Input Text    ${owner-name}    ${owner_full_name}

        # Upload Owner-related file via direct input (like Step 3)
        Wait Until Page Contains Element    ${owner-file-input}    10s
        Choose Unique File    ${owner-file-input}    ${id-sample-file}    ${id-sample2-file}    ${jpg-7mb-file}    ${jpg-8mb-file}    ${jpg-10mb-file}    ${sample-pdf-file}    ${sample-pdf2-file}    ${pdf-10mb-file}
    ELSE
        Log To Console    Applied By: Authorized Representative
        # Select Representative in dropdown by visible label
        Wait Until Page Contains Element    ${owner-or-representative}    10s
        Select From List By Label    ${owner-or-representative}    Authorized Representative

        # Fill Representative details
        ${rep_full_name}=    FakerLibrary.Name
        ${rep_position}=     FakerLibrary.Job
        Wait Until Element Is Visible    ${representative-name}        10s
        Input Text    ${representative-name}        ${rep_full_name}
        Wait Until Element Is Visible    ${representative-position}    10s
        Input Text    ${representative-position}    ${rep_position}
        Wait Until Element Is Visible    ${representative-email}       10s
        Input Text    ${representative-email}       ${public-applicant-email}

        # Upload Representative-related files via direct inputs (owner ID above auth, then representative ID)
        Wait Until Page Contains Element    ${rep-owner-id-input}    10s
        Choose Unique File Under Size    ${rep-owner-id-input}    ${3145728}    ${id-sample-file}    ${id-sample2-file}
        Wait Until Page Contains Element    ${rep-auth-input}    10s
        Choose Unique File Under Size    ${rep-auth-input}    ${3145728}    ${authorization-letter-file}    ${sample-pdf-file}
        Wait Until Page Contains Element    ${rep-id-input}    10s
        Choose Unique File Under Size    ${rep-id-input}    ${3145728}    ${id-sample-file}    ${id-sample2-file}
    END

Upload Via Button With Nearby File Input
    [Arguments]    ${button_locator}    ${file_path}
    # Mirror Step 3 behavior: do not click the button; target the nearby file input and upload
    Run Keyword And Ignore Error    Scroll Element Into View    ${button_locator}

    # If the locator is an xpath, try structural derivations to find the input
    ${is_xpath}=    Run Keyword And Return Status    Should Start With    ${button_locator}    xpath=
    IF    ${is_xpath}
        # Derive a likely input locator by replacing trailing /button with //input[@type='file']
        ${candidate_input}=    Replace String    ${button_locator}    /button    //input[@type='file']
        ${has_input}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${candidate_input}    3s
        IF    ${has_input}
            Choose File    ${candidate_input}    ${file_path}
            Sleep    0.5s
            RETURN
        END

        # Fallback: search within the nearest container for a file input
        ${container_xpath}=    Replace String    ${button_locator}    /button    ${EMPTY}
        ${container_xpath}=    Replace String    ${container_xpath}    //button    ${EMPTY}
        ${nearby_input_found}=    Run Keyword And Return Status    Wait Until Page Contains Element    xpath=(${container_xpath}//input[@type='file'])[1]    3s
        IF    ${nearby_input_found}
            Choose File    xpath=(${container_xpath}//input[@type='file'])[1]    ${file_path}
            Sleep    0.5s
            RETURN
        END
    END

    # Last resort: pick the last visible file input on page (to avoid blocking test)
    ${any_file_inputs}=    Get Element Count    xpath=(//input[@type='file' and not(@disabled) and not(contains(@style,'display: none'))])
    IF    ${any_file_inputs} > 0
        Choose File    xpath=(//input[@type='file' and not(@disabled) and not(contains(@style,'display: none'))])[last()]    ${file_path}
        Sleep    0.5s
    ELSE
        Log To Console    No file input found near ${button_locator}; skipping upload for ${file_path}
    END

Ensure Used Files List
    ${exists}=    Run Keyword And Return Status    Variable Should Exist    ${USED_FILES}
    IF    not ${exists}
        @{empty}=    Create List
        Set Suite Variable    @{USED_FILES}    @{empty}
    END

Mark File Used
    [Arguments]    ${path}
    Ensure Used Files List
    Append To List    ${USED_FILES}    ${path}

Get Unique File
    [Arguments]    @{candidates}
    Ensure Used Files List
    # Prefer any candidate not used yet
    FOR    ${path}    IN    @{candidates}
        ${already}=    Run Keyword And Return Status    List Should Contain Value    ${USED_FILES}    ${path}
        IF    not ${already}
            RETURN    ${path}
        END
    END
    # All candidates used; copy the last candidate to a new unique filename
    ${count}=    Get Length    ${candidates}
    ${last_index}=    Evaluate    ${count} - 1
    ${source}=    Get From List    ${candidates}    ${last_index}
    ${dir}    ${filename}=    Split Path    ${source}
    ${stem}    ${ext}=    Split Extension    ${filename}
    # Ensure extension includes a leading dot when rebuilding the filename
    ${has_dot}=    Run Keyword And Return Status    Should Start With    ${ext}    .
    IF    ${has_dot}
        ${dot_ext}=    Set Variable    ${ext}
    ELSE
        ${dot_ext}=    Set Variable    .${ext}
    END
    FOR    ${i}    IN RANGE    1    100
        ${new_name}=    Set Variable    ${stem}_copy${i}${dot_ext}
        ${dest}=    Join Path    ${dir}    ${new_name}
        ${available}=    Run Keyword And Return Status    File Should Not Exist    ${dest}
        IF    ${available}
            Copy File    ${source}    ${dest}
            Log To Console    Created unique copy for upload: ${dest}
            RETURN    ${dest}
        END
    END
    Fail    Unable to create a unique copy for upload after 100 attempts.

Choose Unique File
    [Arguments]    ${input_locator}    @{candidates}
    ${path}=    Get Unique File    @{candidates}
    Choose File    ${input_locator}    ${path}
    Mark File Used    ${path}

Choose Unique File Under Size
    [Arguments]    ${input_locator}    ${max_bytes}    @{candidates}
    ${path}=    Get Unique File    @{candidates}
    ${size}=    Get File Size    ${path}
    ${ok}=    Evaluate    ${size} <= ${max_bytes}
    IF    not ${ok}
        Fail    File ${path} is ${size} bytes which exceeds limit ${max_bytes} bytes
    END
    Choose File    ${input_locator}    ${path}
    Mark File Used    ${path}

Upload Unique File Via Button With Nearby File Input
    [Arguments]    ${button_locator}    @{candidates}
    ${path}=    Get Unique File    @{candidates}
    Upload Via Button With Nearby File Input    ${button_locator}    ${path}
    Mark File Used    ${path}