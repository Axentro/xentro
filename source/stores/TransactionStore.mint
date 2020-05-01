record SenderPrivatePublic {
  wif : String,
  publicKey : String
}

record TransactionResponse {
  result : ScaledTransaction,
  status : String
}

record SignedTransactionRequest {
  transaction : ScaledTransaction
}

store TransactionStore {
  state sendError : String = ""
  state sendSuccess : String = ""
  state reset : Bool = false

  fun setError (error : String) : Promise(Never, Void) {
    next { sendError = error }
  }

  fun setSuccess (message : String) : Promise(Never, Void) {
    next { sendSuccess = message }
  }

  fun resetErrorSuccess : Promise(Never, Void) {
    next { sendError = "", sendSuccess = ""}
  }

  fun resetStatus (status : Bool) : Promise(Never, Void) {
    next { reset = status }
  }

  fun senderPrivatePublic (currentWallet : Maybe(Wallet)) : SenderPrivatePublic {
    currentWallet
    |> Maybe.map(
      (cw : Wallet) {
        {
          wif = cw.wif,
          publicKey = cw.publicKey
        }
      })
    |> Maybe.withDefault(
      {
        wif = "",
        publicKey = ""
      })
  }

  fun sendTransaction (
    event : Html.Event,
    senderAddress : String,
    senderWif : String,
    transaction : Transaction
  ) : Promise(Never, Void) {
    postTransaction(senderWif, transaction)
  }

  fun compactJson (value : String) : String {
    `JSON.stringify(JSON.parse(#{value}, null, 0)) `
  }

  fun postTransaction (wif : String, transaction : Transaction) : Promise(Never, Void) {
    sequence {
      encodedTransaction =
        encode transaction

      response =
        Http.post("http://localhost:3005/api/v1/transaction/unsigned")
        |> Http.stringBody(
          compactJson(Json.stringify(encodedTransaction)))
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error")

      item =
        decode json as TransactionResponse

      unsignedScaledTransaction =
        item.result

      signingKey =
        Sushi.Wallet.getPrivateKeyFromWif(wif)

      signedTransaction =
        Sushi.Wallet.signTransaction(
          signingKey,
          unsignedScaledTransaction)

      signedTransactionRequest =
        { transaction = signedTransaction }

      encodedSignedTransaction =
        encode signedTransactionRequest

      responseSigned =
        Http.post("http://localhost:3005/api/v1/transaction")
        |> Http.stringBody(
          compactJson(Json.stringify(encodedSignedTransaction)))
        |> Http.send()

      jsonSigned =
        Json.parse(responseSigned.body)
        |> Maybe.toResult("Json parsing error")

      itemSigned =
        decode jsonSigned as TransactionResponse

      if (itemSigned.status == "success") {
        next
          {
            sendSuccess = "Transaction was successful: " + itemSigned.result.id,
            reset = true
          }
      } else {
        next { sendError = "Transaction failed" }
      }
    } catch {
      next { sendError = "Oops an unexpected error occured" }
    }
  }

  fun createTokenTransaction (
    senderAddress : String,
    senderPublicKey : String,
    amount : String,
    fee : String,
    recipientAddress : String,
    token : String,
    speed : String
  ) : Transaction {
    {
      id = "",
      action = "send",
      senders =
        [
          {
            address = senderAddress,
            publicKey = senderPublicKey,
            amount = amount,
            fee = fee,
            signature = "0"
          }
        ],
      recipients =
        [
          {
            address = recipientAddress,
            amount = amount
          }
        ],
      message = "0",
      token = token,
      prevHash = "0",
      timestamp = 0,
      scaled = 0,
      kind = speed
    }
  }


  fun createBuyAddressTransaction(senderAddress : String, senderPublicKey : String, name : String , speed : String) : Transaction {
    {
      id = "",
      action = "scars_buy",
      senders =
        [
          {
            address = senderAddress,
            publicKey = senderPublicKey,
            amount = "0",
            fee = "0.001",
            signature = "0"
          }
        ],
      recipients =
        [],
      message = name,
      token = "SUSHI",
      prevHash = "0",
      timestamp = 0,
      scaled = 0,
      kind = speed
    }
  }

}
