component Miner {
  connect Application exposing { numberProcesses, initMinerSlider, setNumberProcesses, minerConnectionStatus }
  connect WalletStore exposing { currentWalletConfig }

  fun componentDidMount {
    sequence {
      initMinerSlider()
    }
  }

  fun showMinerConnectionStatus : Html {
    <div>
      "Mining Processes "
      <{ status }>
    </div>
  } where {
    status =
      case (minerConnectionStatus) {
        ConnectionStatus::Initial => <i class="fa fa-wifi"/>
        ConnectionStatus::Connected => <i class="text-success fa fa-wifi"/>
        ConnectionStatus::Disconnected => <i class="text-danger fa fa-exclamation-circle"/>
        ConnectionStatus::Error => <i class="text-danger fa fa-exclamation-circle"/>
        ConnectionStatus::Receiving => <i class="text-primary fa fa-wifi"/>
      }
  }

  fun render {
    <div class="card">
      <div class="card-body">
        <div class="d-flex justify-content-between mb-3">
          <div class="col-12">
            <p class="text-muted">
              <{ showMinerConnectionStatus() }>
            </p>

            <input
              type="text"
              class="form-control"
              id="number-processes"/>
          </div>
        </div>
      </div>
    </div>
  }
}
