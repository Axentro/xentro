component Navigation {
  property current : String = "home"

  fun activeStyle (item : String) : String {
    if (item == current) {
      "bg-info"
    } else {
      ""
    }
  }

  fun render : Html {
    <div class="header-body">
      <div class="header-body-left">
        <ul class="navbar-nav">
          <li class="nav-item">
            <a
              class={"nav-link " + activeStyle("home")}
              href="/">

              "Home"

            </a>
          </li>

          <li class="nav-item">
            <a
              class={"nav-link " + activeStyle("send")}
              href="/send">

              "Send"

            </a>
          </li>

          <li class="nav-item">
            <a
              class={"nav-link " + activeStyle("receive")}
              href="/receive">

              "Receive"

            </a>
          </li>

          <li class="nav-item">
            <a
              class={"nav-link " + activeStyle("tools")}
              href="tools">

              "Tools"

            </a>
          </li>
        </ul>
      </div>

      <div class="header-body-right">
        <ul class="navbar-nav">
          <li class="nav-item">
            <a
              class="nav-link"
              href="#">

              "Logout"

            </a>
          </li>
        </ul>
      </div>
    </div>
  }
}
