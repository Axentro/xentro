routes {
  / {
    Application.setPage("login")
  }

  /register {
    Application.setPage("register")
  }

  /dashboard {
    Application.setPage("dashboard")
  }

  /send {
    Application.setPage("send")
  }

  /receive {
    Application.setPage("receive")
  }

  /tools {
    Application.setPage("tools")
  }

  /login {
    Application.setPage("login")
  }

  /create {
    Application.setPage("create")
  }

  * {
    Application.setPage("not_found")
  }
}
