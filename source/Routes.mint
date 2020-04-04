routes {
  / {
    Application.setPage("dashboard")
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

  * {
    Application.setPage("not_found")
  }
}
