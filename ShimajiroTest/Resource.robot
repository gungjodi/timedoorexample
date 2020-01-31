*** Settings ***
Library         SeleniumLibrary    timeout=5     implicit_wait=10    run_on_failure=Capture Page Screenshot  screenshot_root_directory=reportOutput

*** Variables ***
${BROWSER}          Chrome
${LOGIN URL}        https://shimajiro.id/login
${DELAY}            0.1

*** Keywords ***
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