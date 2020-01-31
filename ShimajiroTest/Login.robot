*** Settings ***
Documentation     A test suite for login.
Resource          Resource.robot
Test Setup        Open Browser To Login Page
Test Teardown     Close Browser

*** Variables ***
${email_field}  id:email
${password_field}  id:Password
${remember_me_check}  css:\#loginForm > div.row.text-center.mrg-btm-15 > div.col-xs-12.col-sm-6.sm-text-left > label
${forgot_password_link}  css:\#loginForm > div.row.text-center.mrg-btm-15 > div.col-xs-12.col-sm-6.sm-text-right > a
${login_button}  css:\#loginForm > button
${belum_punya_akun_link}  css:\#register > div > div > div > div > div.normal-login > div > div.col-xs-12.col-sm-6.sm-text-left > a
${daftar_disini_button}  css:\#register > div > div > div > div > div.normal-login > div > div.col-xs-12.col-sm-6.sm-text-right > a
${login_error_message}  css:\#register > div > div > div > div > div.mrg-btm-15.alert.alert-danger > p
${home_account_text}  css:\#dropdownMenu1 > span.hidden-xs.hidden-sm
${home_logo}  css:\body > header > nav > div.container > div > a > img:nth-child(2)

*** Test Cases ***
Login using valid credential
    Input Text  ${email_field}  test@getnada.com
    Input Text  ${password_field}  P@ssw0rd123
    Click Element  ${login_button}
    User should be logged in

Login using invalid email
    Input Text  ${email_field}  invalid_email@email.com
    Input Text  ${password_field}  validpassword
    Click Element  ${login_button}
    Element Text Should Be  ${login_error_message}  Email atau password yang anda masukkan salah

Login using invalid password
    Input Text  ${email_field}  valid@email.com
    Input Text  ${password_field}  invalidpassword
    Click Element  ${login_button}
    Element Text Should Be  ${login_error_message}  Email atau password yang anda masukkan salah

Login with Remember Me Checked
    Input Text  ${email_field}  test@getnada.com
    Input Text  ${password_field}  P@ssw0rd123
    Click Element  ${remember_me_check}
    Click Element  ${login_button}
    User should be logged in
    
Check Forgot Password Link is Visible
    Element Should Be Visible  ${forgot_password_link}

Check Belum Punya Akun Link is Visible
    Element Should Be Visible  ${belum_punya_akun_link}

Check Daftar Disini Button is Visible
    Element Should Be Visible  ${daftar_disini_button}

*** Keywords  ***
User should be logged in
    Element Text Should Be  ${home_account_text}  Hi, Test
    Element Should Be Visible  ${home_logo}