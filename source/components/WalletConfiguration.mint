component WalletConfiguration {
  connect WalletStore exposing { currentWallet, currentWalletConfig }

  state node : String = currentWalletConfig.node
  state speed : String = currentWalletConfig.speed

  fun onNode (event : Html.Event) {
    next { node = Dom.getValue(event.target) }
  }

  fun onSpeed (event : Html.Event) {
    next { speed = Dom.getValue(event.target) }
  }

  get speedOptions : Array(String) {
    ["SLOW", "FAST"]
  }

  fun update (event : Html.Event) {
    Promise.never()
  }

  fun render : Html {
    <div class="card border-dark mb-3">
      <div class="card-body">
        <h5 class="card-title">
          "Wallet Configuration"
        </h5>

        <div>
          <div>
            <div
              class="alert alert-info alert-with-border"
              role="alert">

              <p>
                "Blockchain node"
              </p>

              <hr/>

              <p class="mb-0">
                <ul class="ml-3">
                  <li>
                    "- http://testnet.sushichain.io:3000"
                  </li>

                  <li>
                    "- http://mainnet.sushichain.io:3000"
                  </li>
                </ul>
              </p>

              <div class="mt-1">
                <input
                  type="text"
                  class="form-control"
                  id="blockchain-node"
                  onInput={onNode}
                  value={node}/>
              </div>

            </div>

            <div class="mb-3">
              <label for="transaction-speed">
                "Transaction speed"
              </label>

              <select
                onChange={onSpeed}
                class="form-control"
                id="speed">

                <{ UiHelper.selectNameOptions(speed, speedOptions) }>

              </select>
            </div>
          </div>

          <button
            onClick={update}
            class="btn btn-secondary"
            type="submit">

            "Update"

          </button>
        </div>
      </div>
    </div>
  }
}
