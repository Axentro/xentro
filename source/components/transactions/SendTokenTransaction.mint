component SendTokenTransaction {
  connect WalletStore exposing { currentWallet }
  connect TransactionStore exposing { sendError, senderPrivatePublic, createTokenTransaction, sendTransaction }

  property senderAddress : String
  property tokens : Array(Token)

  state recipientAddress : String = ""
  state amount : String = ""
  state amountError : String = ""
  state recipientError : String = ""
  state fee : String = "0.0001"
  state selectedToken : String = "SUSHI"
  state speed : String = "SLOW"

  fun onToken (event : Html.Event) {
    next
      {
        selectedToken = Dom.getValue(event.target),
        amount = ""
      }
  }

  fun onSpeed (event : Html.Event) {
    next
      {
        speed = Dom.getValue(event.target)
      }
  }

  fun onRecipientAddress (event : Html.Event) {
    next
      {
        recipientAddress = value,
        recipientError = validateRecipientAddress(value)
      }
  } where {
    value =
      Dom.getValue(event.target)
  }

  fun onAmount (event : Html.Event) : Promise(Never, Void) {
    next
      {
        amount = value,
        amountError = validateAmount(value, tokens, selectedToken, fee)
      }
  } where {
    value =
      Dom.getValue(event.target)
  }

  fun validateRecipientAddress (value : String) : String {
    if (last == ".sc") {
      ""
    } else {
      try {
        valid =
          Sushi.Wallet.isValidAddress(value)

        if (valid) {
          ""
        } else {
          "The address you supplied is invalid!"
        }
      } catch {
        "The address you supplied is invalid!"
      }
    }
  } where {
    last =
      `#{value}.slice(-3)`
  }

  fun validateAmount (
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

  get tokenOptions : Array(String) {
    Array.insertAt("SUSHI", 0, otherTokens)
  } where {
    otherTokens =
      tokens
      |> Array.map(.name)
      |> Array.reject((name : String) { String.toLowerCase(name) == "sushi" })
  }

  get speedOptions : Array(String) {
    ["SLOW","FAST"]
  }

  get sendButtonState : Bool {
    String.isEmpty(recipientAddress) || String.isEmpty(amount) || !String.isEmpty(amountError) || !String.isEmpty(recipientError)
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

              <div>
                <{ UiHelper.errorAlert(recipientError) }>
              </div>
            </div>
          </div>

          <div class="form-row">
            <div class="col-md-3 mb-3">
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

              <div>
                <{ UiHelper.errorAlert(amountError) }>
              </div>
            </div>

            <div class="col-md-3 mb-3">
              <label for="token-to-send">
                "Token"
              </label>

              <select
                onChange={onToken}
                class="form-control"
                id="token">

                <{ UiHelper.selectNameOptions(selectedToken, tokenOptions) }>

              </select>
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
