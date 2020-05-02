component Navigation {
  connect WalletStore exposing { resetWallet, currentWalletName }
  connect Application exposing { resetWalletInfo, connectionStatus, resetWebSocket }

  property current : String = "home"

  fun showConnectionStatus : Html {
    <div>
      <{ status }>
    </div>
  } where {
    status =
      case (connectionStatus) {
        ConnectionStatus::Initial => <i class="fa fa-wifi"/>
        ConnectionStatus::Connected => <i class="text-success fa fa-wifi"/>
        ConnectionStatus::Disconnected => <i class="text-danger fa fa-exclamation-circle"/>
        ConnectionStatus::Error => <i class="text-danger fa fa-exclamation-circle"/>
        ConnectionStatus::Receiving => <i class="text-info fa fa-wifi"/>
      }
  }

  fun activeStyle (item : String) : String {
    if (item == current) {
      "btn-info"
    } else {
      "btn-outline-info"
    }
  }

  fun logout (event : Html.Event) : Promise(Never, Void) {
    sequence {
      resetWallet
      resetWalletInfo
      resetWebSocket
      `location.reload()`
    }
  }

  fun render : Html {
    <div class="header-body">
      <div class="header-body-left">
        <ul class="navbar-nav">
          <li class="nav-item">
            <a
              class={"mr-2 btn " + activeStyle("home")}
              href="/dashboard">

              "Home"

            </a>
          </li>

          <li class="nav-item">
            <a
              class={"mr-2 btn " + activeStyle("send")}
              href="/send">

              "Send"

            </a>
          </li>

          <li class="nav-item">
            <a
              class={"mr-2 btn " + activeStyle("receive")}
              href="/receive">

              "Receive"

            </a>
          </li>

          <li class="nav-item">
            <a
              class={"mr-2 btn " + activeStyle("address")}
              href="/address">

              "Address"

            </a>
          </li>

          <li class="nav-item">
            <a
              class={"mr-2 btn " + activeStyle("tools")}
              href="tools">

              "Tools"

            </a>
          </li>
        </ul>
      </div>

      <div class="header-body-right">
        <ul class="navbar-nav">
          <li class="mr-2 nav-item">
            <{ currentWalletName }>
          </li>

          <li class="mr-3 nav-item">
            <{ showConnectionStatus() }>
          </li>

          <li class="nav-item">
            <a
              onClick={logout}
              class="btn btn-outline-secondary"
              href="#">

              "Logout"

            </a>
          </li>
        </ul>
      </div>
    </div>
  }
}
