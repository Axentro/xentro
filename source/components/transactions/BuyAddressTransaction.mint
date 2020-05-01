component BuyAddressTransaction {
  connect WalletStore exposing { currentWallet }

  connect TransactionStore exposing {
    sendError,
    sendSuccess,
    resetStatus,
    resetErrorSuccess,
    reset,
    senderPrivatePublic,
    createBuyAddressTransaction,
    sendTransaction
  }

  property senderAddress : String

  state name : String = ""
  state nameError : String = ""
  state speed : String = "SLOW"
  state confirmCheck : Bool = false

 fun componentDidMount : Promise(Never, Void) {
    resetErrorSuccess()
 }

  fun componentDidUpdate : Promise(Never, Void) {
    if (reset) {
      sequence {
        next
          {
            name = "",
            speed = "SLOW",
            confirmCheck = false
          }

        resetStatus(false)
      }
    } else {
      Promise.never()
    }
  }



  fun onName (event : Html.Event) {
    next { name = Dom.getValue(event.target) }
  }

    fun onSpeed (event : Html.Event) {
    next { speed = Dom.getValue(event.target) }
  }
  

 fun onCheck (event : Html.Event) {
    next { confirmCheck = !confirmCheck }
  } where {
    value = Dom.getValue(event.target)
  }

  fun validateFeeAmount (
    value : String,
    tokens : Array(Token),
    currentToken : String,
    currentFee : String
  ) : String {
    try {
      amt =
        Number.fromString(value)
        |> Maybe.withDefault(0)

      fee =
        Number.fromString(currentFee)
        |> Maybe.withDefault(0.0001)

      tokenAmount =
        tokens
        |> Array.find(
          (token : Token) : Bool {
            String.toLowerCase(token.name) == String.toLowerCase(currentToken)
          })
        |> Maybe.map((token : Token) : Maybe(Number) { Number.fromString(token.amount) })
        |> Maybe.flatten
        |> Maybe.withDefault(0)

      if (amt + fee > tokenAmount) {
        "You don't have enough " + currentToken + " to send"
      } else if (amt <= 0) {
        "you must supply an amount greater than 0"
      } else {
        ""
      }
    }
  }

  get speedOptions : Array(String) {
    ["SLOW", "FAST"]
  }

  get buyButtonState : Bool {
    String.isEmpty(name) || !confirmCheck
  }

  fun render : Html {
    <div class="card border-dark mb-3">
      <div class="card-body">
        <h4 class="card-title">
          "Buy Human Readable Address"
        </h4>

        <{ UiHelper.errorAlert(sendError) }>
        <{ UiHelper.successAlert(sendSuccess) }>

        <div>
          <div class="form-row mb-3">
            <div class="col-md-8 mb-6">
              <label for="recipient-address">
                "Name of human readable address"
              </label>

              <input
                type="text"
                class="form-control"
                id="address-name"
                placeholder="Human readable address"
                onInput={onName}
                value={name}/>

              <div class="mt-2">
                <{ UiHelper.errorAlert(nameError) }>
              </div>
            </div>

             <div class="col-md-3 mb-3">
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

          <div class="form-group">
            <div class="custom-control custom-checkbox custom-checkbox-success">
              <input
                type="checkbox"
                onChange={onCheck}
                class="custom-control-input"
                checked={confirmCheck}
                id="customCheck2"/>

              <label
                class="custom-control-label"
                for="customCheck2">

                "I've double checked everything is correct!"

              </label>
            </div>
          </div>

          <button
            onClick={(e : Html.Event) { sendTransaction(e, senderAddress, senderWif, transaction) }}
            class="btn btn-secondary"
            disabled={buyButtonState}
            type="submit">

            "Buy"

          </button>
        </div>
      </div>
    </div>
  } where {
    senderInfo =
      senderPrivatePublic(currentWallet)

    senderPublicKey =
      senderInfo.publicKey

    senderWif =
      senderInfo.wif

    transaction =
      createBuyAddressTransaction(senderAddress, senderPublicKey, name, speed)
  }
}
