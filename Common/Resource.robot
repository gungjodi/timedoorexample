*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported SeleniumLibrary.
Library         SeleniumLibrary    timeout=5     implicit_wait=10    run_on_failure=Capture Page Screenshot  screenshot_root_directory=reportOutput
Resource        Params.robot

*** Variables ***
${BROWSER}          Chrome
${LOGIN URL}        http://twitter.com
${DELAY}  0.2

*** Keywords ***
##########          LOGGING IN KEYWORDS START       ####################
Create Chrome Web Driver And Open Browser
    ${chrome_options}=    Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --window-size\=1920,1080
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    #Call Method    ${chrome_options}    add_argument    --headless      #comment this to open visible browser
    Call Method    ${chrome_options}    add_argument    --ignore-ssl-errors
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    Create Webdriver  ${BROWSER}    chrome_options=${chrome_options}

Open Browser To Login Page
    Create Chrome Web Driver And Open Browser
    Set Selenium Speed    ${DELAY}
    Go To   ${LOGIN URL}
    Login Page Should Be Opened

Login Page Should Be Opened
    Wait And Verify Is Visible   ${login_button}

##########          COMMON KEYWORDS START       ####################

#Wait for input field to be visible, clear text field, then input value
#USAGE:     Wait And Input  <locator>   <value>
Wait And Input
    [Arguments]  ${locator}  ${text}
    Wait Until Element Is Visible    ${locator}
    Clear Element Text  ${locator}
    Input Text  ${locator}  ${text}

#Wait for input field to be visible, then click element
#USAGE:     Wait And Click  <locator>
Wait And Click
    [Arguments]  ${locator}
    Wait Until Element Is Visible    ${locator}
    Click Element  ${locator}

Wait Enabled And Click
    [Arguments]  ${locator}
    Wait Until Element Is Enabled    ${locator}
    Click Element  ${locator}

Wait And Verify Is Visible
    [Arguments]  ${locator}
    Wait Until Element Is Visible  ${locator}
    Element Should Be Visible  ${locator}

Wait And Get Text
    [Arguments]  ${locator}
    Wait Until Element Is Visible  ${locator}
    ${text}=  Get Text  ${locator}
    [Return]  ${text}

Wait And Verify Element Contains Text
    [Arguments]  ${text}
    ${locator}=  Set Variable  xpath=//*[text()[contains(.,'${text}')]]
    Wait And Verify Is Visible  ${locator}

Get Element Contains Text
    [Arguments]  ${text}
    ${locator}=  Set Variable  xpath=//*[text()[contains(.,'${text}')]]
    ${element}=  Get WebElement  ${locator}
    [Return]  ${element}

Verify Text Is Visible
    [Arguments]  ${text}
    ${element}=  Get Element Contains Text  ${text}
    Element Should Be Visible  ${element}

Click Element Contains Text
    [Arguments]  ${text}
    ${locator}=  Set Variable  xpath=//*[text()[contains(.,'${text}')]]
    Wait And Click  ${locator}

Select Option
    [Arguments]     ${locator}  ${value}
    log  Open Select field and choose ${value} on dropdown list
    Wait Until Keyword Succeeds     10s     1s      Open Select   ${locator}  ${value}

Open Select
    [Arguments]     ${locator}  ${value}
    Wait And Click  ${locator}
    Wait Until Element Is Visible   ${select_options_body}
    ${element_locator}=     Set Variable    //span[text()="${value}"]
    ${elements}=    Get WebElements     ${element_locator}
    ${element_count}=   Get Element Count   ${element_locator}
    ${index_selected}=  Evaluate    ${element_count} - 1
    ${option}=  Set Variable    ${elements}[${index_selected}]
    Run Keyword If  ${element_count}==0     Scroll Down In Element  ${select_options_body}
    Wait And Click  ${option}

Click Side Menus
    [Arguments]    ${locator}
    Wait And Click    ${locator}

Check Form Error
    Sleep   1
    Element Should Not Be Visible   ${form_error}

Check If There Is Page Error
     Sleep    1
     Element Should Not Be Visible    ${toast_text}

Success Toast Should Contains
    [Arguments]     ${expected_text}
    Wait Until Element Is Visible   ${toast_text}
    Element Should Contain  ${toast_text}    ${expected_text}

Scroll Down
    Execute JavaScript    window.scrollBy(${0},${250})

Scroll Up
    Execute JavaScript    window.scrollBy(${0},${-250})

Scroll Left In Element
    [Arguments]     ${css_selector}
    ${command}=  Set Variable    document.querySelector("${css_selector}").scrollLeft+=250
    Execute JavaScript  ${command}

Scroll Down In Element
    [Arguments]     ${css_selector}
    ${command}=  Set Variable    document.querySelector("${css_selector}").scrollTop+=250
    Execute JavaScript  ${command}

Continous Scroll
    [Arguments]  ${locator}
    ${elements}=    Get WebElements     ${locator}
    ${element_count}=   Get Element Count   ${locator}
    Run Keyword If  ${element_count}==0  Scroll Down
    Element Should Be Visible  ${locator}

Scroll Down Until Element Is Visible
    [Arguments]  ${locator}
    Wait Until Keyword Succeeds  10s  1s  Continous Scroll  ${locator}

Close Browser And Take Screenshot
    Capture Page Screenshot
    Close Browser

Set Test Fail And Stop Test
    [Arguments]  ${message}
    Fail  ${message}
    Fatal Error

##########          ADD SOME NEW COMMON KEYWORD ABOVE THIS LINE       ####################
##########          COMMON KEYWORDS END                               ####################