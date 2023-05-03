# Assignment3_OnlineAppointment
## Project Description

This is an online appointment system for hospital, It allows our clients use the application to make an appointment with the doctor they need. 

## Login Page

- Description:
  - Login Page is the first page when our client open the application, it allows our clients use their email and password to log into their accounts
- Function: 
  - This page contains 2 text boxes, one is used to enter the email and the other one is used to enter the password 
  - This page should contains 2 buttons, one is the login button and the other is the register button 
  - When user clicked on the login button, should check the email and the password, if all these information are correct, it will redirector to the main page. Otherwise, it will comes out a hit or a label shows "The user name or password are incorrect"
  - When user clicked on the register button, it will redirectory to the register page 
- 功能概述
  - 本页面由两个文本输入框以及两个按钮组成 
  - 输入框用于用户输入用户名和密码，两个按钮分别为登陆和注册 
  - 当登陆按钮被点击时，需要校验用户名和密码是否存在，当两条信息匹配成功时，页面重定向到主页面 ，当用户名或密码不正确时，则会出现提示“用户名或密码错误”

## Register Page

- Description:

  - This page only appear when user click on Register button on login page 

- Function 

  - This page contains sever text boxes for users to enter their information, and on register button 
  - when register button be clicked, should check all the information is not empty and store this information as an entity 

- 功能概述 

  - 本页面需要有多个输入框用于用户添加用户信息，以及一个注册按钮

  - 当注册按钮被点击时，需要检查所有的输入框中的信息不可为空，如果为空则会出现提示“本信息不可为空”，当所有信息通过检查后需要将这些信息封装成一个 structure 并保存 

    ```swift
    struct User(){
      var appointmentId[]: [Int] ?  // 一个user 可以有多个appointment id
      var userId: Int ? // 此处user id 需要为一个字增 id， 每次调用创建则 +1 初始为 1或 0001
      var email: String
      var userName: String
      var password: String
      ...
    }
    ```

## View Profile Page

- Description
  - This page used to show user's information only for view, user has no permission to edit this information 
- Function:
  - Read this user's information and show these information in a table view and also contain a button to back to the main page 
- 功能概述 
  - 本页面用于用户查看个人信息，用户只可以查看不可以修改 
  - 本页面包含一个按钮点击按钮会回到主页面 

