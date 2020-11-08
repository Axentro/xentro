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

  /settings {
    Application.setPage("settings")
  }

  /address {
    Application.setPage("address")
  }

  /tokens {
    Application.setPage("tokens")
  }

  /transactions {
    Application.setPage("transactions")
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
