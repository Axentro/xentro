component WalletConfiguration {
  connect WalletStore exposing { currentWallet, currentWalletConfig, updateWallet, encryptedWalletWithConfig }
  connect Application exposing { updateWebSocketConnect, webSocket }

  state node : String = currentWalletConfig.node
  state speed : String = currentWalletConfig.speed

  fun onNode (event : Html.Event) {
    next { node = Dom.getValue(event.target) }
  }

  fun onSpeed (event : Html.Event) {
    next { speed = Dom.getValue(event.target) }
  }

  fun onNodeChange (event : Html.Event) {
    next { node = selectOrValue(Dom.getValue(event.target)) }
  }

  fun selectOrValue (value : String) : String {
    if (value == "select") {
      ""
    } else {
      value
    }
  }

  get speedOptions : Array(String) {
    ["SLOW", "FAST"]
  }

  get nodeOptions : Array(String) {
    ["select", "http://testnet.sushichain.io:3000", "http://mainnet.sushichain.io:3000"]
  }

  fun update (event : Html.Event) {
    sequence {
      encryptedWalletWithConfig
      |> Maybe.map(
        (ewc : EncryptedWalletWithConfig) {
          sequence {
            updateWallet(
              ewc.wallet,
              Maybe.just(
                {
                  node = node,
                  speed = speed
                }))

            updateWebSocketConnect(currentWalletConfig.node)
          }
        })

      webSocket
      |> Maybe.map(WebSocket.close)
    }
  }

  fun render : Html {
    <div class="card border-dark mb-3">
      <div class="card-body">
        <h5 class="card-title">
          "Wallet Configuration"
        </h5>

        <div>
          <div>
            <div class="mb-3">
              <label for="blockchain-node">
                "Blockchain node"
              </label>

              <select
                onChange={onNodeChange}
                class="form-control"
                id="node-change">

                <{ UiHelper.selectNameOptions(node, nodeOptions) }>

              </select>

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
