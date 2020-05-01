record SenderPrivatePublic {
  wif : String,
  publicKey : String
}

record TransactionResponse {
  result : ScaledTransaction,
  status : String
}

record ScarsResolveResponse {
  status : String,
  resolved : ScarsResolved using "result"
}

record ScarsResolved {
  resolved: Bool,
  domain: ScarsDomain
}

record ScarsDomain {
  address: String
}

record SignedTransactionRequest {
  transaction : ScaledTransaction
}

store TransactionStore {
  state sendError : String = ""
  state sendSuccess : String = ""
  state reset : Bool = false
  state resolvedSenderAddress : String = ""

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
    recipientAddress : String,
    senderWif : String,
    transaction : Transaction
  ) : Promise(Never, Void) {
    sequence {
      resolveDomainAddress(recipientAddress)
      postTransaction(recipientAddress, senderWif, transaction)
    }
  }

  fun compactJson (value : String) : String {
    `JSON.stringify(JSON.parse(#{value}, null, 0)) `
  }

  fun isDomainAddress(value : String) : Bool {
      `#{value}.slice(-3)` == ".sc"
  }

  fun resolveDomainAddress(recipientAddress : String) : Promise(Never, Void) {
     if (isDomainAddress(recipientAddress)) {
       sequence {
         resolveResponse = Http.get("http://localhost:3005/api/v1/scars/" + recipientAddress)
        |> Http.send()

        jsonResolved = Json.parse(resolveResponse.body)
        |> Maybe.toResult("Json parsing error with domain")

        resolveResult = decode jsonResolved as ScarsResolveResponse

        Debug.log(resolveResult)
        next { resolvedSenderAddress = resolveResult.resolved.domain.address }
       } catch {
         next { sendError = "Oops there was an error with address: " + recipientAddress }
       }
       } else {
         next { resolvedSenderAddress = recipientAddress }
       }
  }


  fun postTransaction (senderAddress : String, wif : String, transaction : Transaction) : Promise(Never, Void) {
    sequence {

      /* need to update the transaction here and replace the to_address with the resolvedSenderAddress */

      encodedTransaction =
        encode transaction

      requestBody = String.replace(senderAddress, resolvedSenderAddress, compactJson(Json.stringify(encodedTransaction)))  

      response =
        Http.post("http://localhost:3005/api/v1/transaction/unsigned")
        |> Http.stringBody(requestBody)
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
