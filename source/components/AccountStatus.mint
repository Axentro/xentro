component AccountStatus {

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


  fun render {
    <div class="card d-block d-sm-none">
      <div
        class="card-body card-scroll"
        style="height:150px;">

        <div class="row col-12">
            <span class="mr-1"><{ showConnectionNode }></span>
            <span class="mr-1"><{ showConnectionStatus() }></span>
             <a
              onClick={logout}
              class="btn btn-sm btn-outline-secondary"
              href="#">

              "Logout"

            </a>
       </div>

           <div class="mt-1">
            <{ showWalletName }>
          </div>

       <div>
           
       
    </div>
    </div>
    </div>
  }
}
