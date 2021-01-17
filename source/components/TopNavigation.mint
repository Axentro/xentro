component TopNavigation {
  connect WalletStore exposing { resetWallet, currentWalletName, currentWalletConfig }
  connect Application exposing { resetWalletInfo, connectionStatus, resetWebSocket }

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
        ConnectionStatus::Receiving => <i class="text-primary fa fa-wifi"/>
      }
  }

  get showConnectionNode : Html {
    try {
      env =
        NodeHelper.nodeEnv(currentWalletConfig.node)

      case (env) {
        NodeEnv::MainNet =>
          <span class="badge badge-success">
            "MainNet"
          </span>

        NodeEnv::TestNet =>
          <span class="badge badge-info">
            "TestNet"
          </span>

        NodeEnv::Local =>
          <span class="badge badge-secondary">
            "Local"
          </span>
      }
    }
  }

  get showWalletName : Html {
    <span class="badge badge-info">
      <{ currentWalletName }>
    </span>
  }



  fun logout (event : Html.Event) : Promise(Never, Void) {
    sequence {
      resetWallet
      resetWalletInfo
      resetWebSocket
      `window.location.replace('/')`
    }
  }

  fun render : Html {
    <div class="header-body">
      <div class="header-body-left">
        <ul class="navbar-nav">
         
        </ul>
      </div>

      <div class="header-body-right d-none d-sm-block d-md-block d-lg-block">
        <ul class="navbar-nav"/>

        <ul class="navbar-nav flex-row mb-2">
          <li class="mr-1 nav-item">
            <{ showConnectionNode }>
          </li>

          <li class="mr-3 nav-item">
            <{ showConnectionStatus() }>
          </li>

          <li class="mr-2 nav-item">
            <{ showWalletName }>
          </li>

          <li class="nav-item">
            <a
              onClick={logout}
              class="btn btn-sm btn-outline-secondary"
              href="#">

              "Logout"

            </a>
          </li>
        </ul>
      </div>
    </div>
  }
}
