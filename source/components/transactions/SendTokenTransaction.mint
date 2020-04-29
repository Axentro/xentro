component SendTokenTransaction {
  connect WalletStore exposing { currentWallet }
  connect TransactionStore exposing { sendError, senderPrivatePublic, createTokenTransaction, sendTransaction }

  property senderAddress : String
  property tokens : Array(Token)

  state recipientAddress : String = ""
  state amount : String = ""
  state amountError : String = ""
  state fee : String = ""
  state selectedToken : String = ""
  state speed : String = ""

  fun onToken (event : Html.Event) {
    next { selectedToken = Dom.getValue(event.target), amount = "" }
  }

  fun onRecipientAddress (event : Html.Event) {
    next { recipientAddress = Dom.getValue(event.target) }
  }

   fun onAmount (event : Html.Event) : Promise(Never, Void) {
    next { amount = value, amountError = validateAmount(value, tokens, selectedToken) }
  } where {
    value = Dom.getValue(event.target)
  }

  fun validateRecipient(value : String) : String {
    ""
  }

  fun validateAmount (value : String, tokens : Array(Token), currentToken : String) : String {
    try {
      amt =
        Number.fromString(value)
        |> Maybe.withDefault(0)

      sushi =
        tokens
        |> Array.find(
          (token : Token) : Bool {
           String.toLowerCase(token.name) == String.toLowerCase(currentToken)
          })
        |> Maybe.map((token : Token) : Maybe(Number) { Number.fromString(token.amount) })
        |> Maybe.flatten
        |> Maybe.withDefault(0)

      if (sushi <= (amt + 0.0001) && sushi > 0) {
        "You don't have enough " + currentToken + " to send"
      } else if (amt <= 0) {
        "you must supply an amount greater than 0"
      } else {
        ""
      }
    }
  }

  get tokenOptions : Array(String) {
    Array.insertAt("SUSHI", 0, otherTokens)
  } where {
    otherTokens =
      tokens
      |> Array.map(.name)
      |> Array.reject((name : String) { String.toLowerCase(name) == "sushi" })
  }

 get sendButtonState : Bool {
    String.isEmpty(recipientAddress) || String.isEmpty(amount) || !String.isEmpty(amountError)
  }

  fun render : Html {
    <div class="card border-dark mb-3">
      <div class="card-body">
        <h4 class="card-title">
          "Send tokens"
        </h4>

        <{ UiHelper.errorAlert(sendError) }>

        <div>
          <div class="form-row mb-3">
            <div class="col-md-8 mb-6">
              <label for="recipient-address">
                "Recipient address (or human readable address)"
              </label>

              <input
                type="text"
                class="form-control"
                id="recipient-address"
                placeholder="Recipient address"
                onInput={onRecipientAddress}
                value={recipientAddress}/>

              <div class="valid-feedback">
                "Looks good!"
              </div>
            </div>
          </div>

          <div class="form-row">
            <div class="col-md-4 mb-3">
              <label for="amount-to-send">
                "Amount to send"
              </label>

              <input
                type="text"
                class="form-control"
                id="amount-to-send"
                placeholder="Amount to send"
                onInput={onAmount}
                value={amount}/>

              <{ UiHelper.errorAlert(amountError) }>
            </div>

            <div class="col-md-4 mb-3">
              <label for="token-to-send">
                "Token"
              </label>

              <select
                onChange={onToken}
                class="form-control"
                id="token">

                <{ UiHelper.selectNameOptions(selectedToken, tokenOptions) }>

              </select>

              <div class="invalid-feedback">
                "Please choose a username."
              </div>
            </div>
          </div>

          <div class="form-group">
            <div class="form-check">
              <input
                class="form-check-input"
                type="checkbox"
                value=""
                id="invalidCheck"/>

              <label
                class="form-check-label"
                for="invalidCheck">

                "I've double checked everything is correct!"

              </label>

              <div class="invalid-feedback">
                "You must agree before submitting."
              </div>
            </div>
          </div>

          <button
            onClick={(e : Html.Event) { sendTransaction(e, senderAddress, senderWif, transaction) }}
            class="btn btn-secondary"
            disabled={sendButtonState}
            type="submit">

            "Send"

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
      createTokenTransaction(senderAddress, senderPublicKey, amount, fee, recipientAddress, selectedToken, speed)
  }
}
