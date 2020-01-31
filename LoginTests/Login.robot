*** Settings ***
Documentation     A test suite with a single test for valid login.
...
...               This test has a workflow that is created using keywords in
...               the imported resource file.
Resource          ../Common/Resource.robot

*** Variables ***
${username_field}  //input[@name='session[username_or_email]']
${password_field}  //input[@name='session[password]']
${login_button_homepage}  //a[@data-testid='loginButton']
${login_button_form}  //div[@data-testid='LoginForm_Login_Button']
${home_page_header}  //*[@id="react-root"]/div/div/div/main/div/div/div/div[1]/div/div[1]/div[1]/div/div/div/div/div[1]/div/h2/span
${error_login_message}  //*[@id="react-root"]/div/div/div/main/div/div/div[1]/span

*** Test Cases ***
Verify Login Using Valid Credential
    Open Browser To Login Page
    Wait And Click  ${login_button_homepage}
    Input Username    helloworld21519
    Input Password    Mypasswordis123123
    Wait and click  ${login_button_form}
    Home Page Should Be Open
    [Teardown]    Close Browser

Verify Login Using Invalid Password
    Open Browser To Login Page
    Wait And Click  ${login_button_homepage}
    Input Username    helloworld21519
    Input Password    invalidpassword
    Wait and click  ${login_button_form}
    Element Should Be Visible  ${error_login_message}
    [Teardown]    Close Browser

Verify Login Using Invalid Username
    Open Browser To Login Page
    Wait And Click  ${login_button_homepage}
    Input Username    invalidusername
    Input Password    Mypasswordis123123
    Wait and click  ${login_button_form}
    Element Should Be Visible  ${error_login_message}
    [Teardown]    Close Browser

*** Keywords ***
Input Username
    [Arguments]  ${text}
    Wait And Input  ${username_field}  ${text}

Input Password
    [Arguments]  ${text}
    Wait And Input  ${password_field}  ${text}

Home Page Should Be Open
    Element Text Should Be  ${home_page_header}  Home Page
