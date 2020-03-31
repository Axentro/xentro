routes {
  
  / {
    Application.setPage("dashboard")
  }
  
  /dashboard {
    Application.setPage("dashboard")
  }

  * {
    Application.setPage("not_found")
  }
}
