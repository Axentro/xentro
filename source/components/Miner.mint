component Miner {
  connect Application exposing { numberProcesses, initMinerSlider, setNumberProcesses}
  connect WalletStore exposing { currentWalletConfig }

  fun componentDidMount {
    sequence {
   initMinerSlider()
    }
  }

  fun render {
    <div class="card">
      <div class="card-body">
       <div class="d-flex justify-content-between mb-3">


            <div class="col-12">
              <p class="text-muted">
              "Mining Processes" <i class="ml-1 fa fa-wifi"></i>
            </p>

              <input
                type="text"
                class="form-control"
                id="number-processes"
                />

            </div>
       
        </div>
    </div>
    </div>
  }
}
