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
  resolved : Bool,
  domain : ScarsDomain
}

record ScarsDomain {
  address : String
}

record TokenListResponse {
  status : String,
  tokens : Array(String) using "result"
}

record SignedTransactionRequest {
  transaction : ScaledTransaction
}

store TransactionStore {
  state sendError : String = ""
  state sendSuccess : String = ""
  state domainError : String = ""
  state tokenError : String = ""

  state reset : Bool = false
  state resolvedSenderAddress : String = ""

  fun setDomainError (error : String) : Promise(Never, Void) {
    next { domainError = error }
  }

  fun setTokenError (error : String) : Promise(Never, Void) {
    next { tokenError = error }
  }

  fun setError (error : String) : Promise(Never, Void) {
    next { sendError = error }
  }

  fun setSuccess (message : String) : Promise(Never, Void) {
    next { sendSuccess = message }
  }

  fun resetErrorSuccess : Promise(Never, Void) {
    next
      {
        sendError = "",
        sendSuccess = "",
        domainError = "",
        tokenError = ""
      }
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
    baseUrl : String,
    recipientAddress : String,
    senderWif : String,
    transaction : Transaction
  ) : Promise(Never, Void) {
    sequence {
      resolveDomainAddress(baseUrl, recipientAddress)
      postTransaction(baseUrl, recipientAddress, senderWif, transaction)
    }
  }

  fun compactJson (value : String) : String {
    `JSON.stringify(JSON.parse(#{value}, null, 0)) `
  }

  fun isDomainAddress (value : String) : Bool {
    `#{value}.slice(-3)` == ".ax"
  }

  fun resolveDomainAddress (baseUrl : String, recipientAddress : String) : Promise(Never, Void) {
    if (isDomainAddress(recipientAddress)) {
      sequence {
        resolveResponse =
          Http.get(baseUrl + "/api/v1/hra/" + recipientAddress)
          |> Http.send()

        jsonResolved =
          Json.parse(resolveResponse.body)
          |> Maybe.toResult("Json parsing error with domain")

        resolveResult =
          decode jsonResolved as ScarsResolveResponse

        if (resolveResult.resolved.resolved) {
          next { resolvedSenderAddress = resolveResult.resolved.domain.address }
        } else {
          next { sendError = "Transaction will be rejected - no address exists for address: " + recipientAddress }
        }
      } catch {
        next { sendError = "Transaction will be rejected - there was an error with address: " + recipientAddress }
      }
    } else {
      next { resolvedSenderAddress = recipientAddress }
    }
  }

  fun domainExists (baseUrl : String, targetName : String) : Promise(Never, Void) {
    sequence {
      resolveResponse =
        Http.get(baseUrl + "/api/v1/hra/" + targetName)
        |> Http.send()

      jsonResolved =
        Json.parse(resolveResponse.body)
        |> Maybe.toResult("Json parsing error with domain")

      resolveResult =
        decode jsonResolved as ScarsResolveResponse

      if (resolveResult.resolved.resolved) {
        next { domainError = "Sorry the name: " + targetName + " is already taken" }
      } else {
        next { domainError = "" }
      }
    } catch {
      sequence {
        if (String.isEmpty(targetName)) {
          next { domainError = "" }
        } else {
          next { domainError = "Oops there was an error checking: " + targetName }
        }
      }
    }
  }

  fun domainDoesNotExist (baseUrl : String, targetName : String) : Promise(Never, Void) {
    sequence {
      resolveResponse =
        Http.get(baseUrl + "/api/v1/hra/" + targetName)
        |> Http.send()

      jsonResolved =
        Json.parse(resolveResponse.body)
        |> Maybe.toResult("Json parsing error with domain")

      resolveResult =
        decode jsonResolved as ScarsResolveResponse

      if (resolveResult.resolved.resolved) {
        next { domainError = "" }
      } else {
        next { domainError = "Sorry the address: " + targetName + " does not exist" }
      }
    } catch {
      sequence {
        if (String.isEmpty(targetName)) {
          next { domainError = "" }
        } else {
          next { domainError = "Oops there was an error checking: " + targetName }
        }
      }
    }
  }

  fun tokenExists (baseUrl : String, token : String) : Promise(Never, Void) {
    sequence {
      resolveResponse =
        Http.get(baseUrl + "/api/v1/tokens")
        |> Http.send()

      jsonResolved =
        Json.parse(resolveResponse.body)
        |> Maybe.toResult("Json parsing error with domain")

      tokenResult =
        decode jsonResolved as TokenListResponse

      if (Array.contains(token, tokenResult.tokens)) {
        next { tokenError = "Sorry the token: " + token + " already exists" }
      } else {
        next { tokenError = "" }
      }
    } catch {
      sequence {
        if (String.isEmpty(token)) {
          next { tokenError = "" }
        } else {
          next { tokenError = "Oops there was an error checking: " + token }
        }
      }
    }
  }

  fun postTransaction (
    baseUrl : String,
    senderAddress : String,
    wif : String,
    transaction : Transaction
  ) : Promise(Never, Void) {
    sequence {
      /* need to update the transaction here and replace the to_address with the resolvedSenderAddress */
      encodedTransaction =
        encode transaction

      requestBody =
        String.replace(senderAddress, resolvedSenderAddress, compactJson(Json.stringify(encodedTransaction)))

      response =
        Http.post(baseUrl + "/api/v1/transaction/unsigned")
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
        Axentro.Wallet.getPrivateKeyFromWif(wif)

      signedTransaction =
        Axentro.Wallet.signTransaction(
          signingKey,
          unsignedScaledTransaction)

      signedTransactionRequest =
        { transaction = signedTransaction }

      encodedSignedTransaction =
        encode signedTransactionRequest

      responseSigned =
        Http.post(baseUrl + "/api/v1/transaction")
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
      kind = speed,
      version = "V1"
    }
  }

  fun createBuyAddressTransaction (
    senderAddress : String,
    senderPublicKey : String,
    name : String,
    speed : String
  ) : Transaction {
    {
      id = "",
      action = "hra_buy",
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
      recipients = [],
      message = name,
      token = "AXNT",
      prevHash = "0",
      timestamp = 0,
      scaled = 0,
      kind = speed,
      version = "V1"
    }
  }

  fun createCustomTokenTransaction (
    senderAddress : String,
    senderPublicKey : String,
    name : String,
    amount : String,
    speed : String
  ) : Transaction {
    {
      id = "",
      action = "create_token",
      senders =
        [
          {
            address = senderAddress,
            publicKey = senderPublicKey,
            amount = amount,
            fee = "10",
            signature = "0"
          }
        ],
      recipients =
        [
          {
            address = senderAddress,
            amount = amount
          }
        ],
      message = "0",
      token = name,
      prevHash = "0",
      timestamp = 0,
      scaled = 0,
      kind = speed,
      version = "V1"
    }
  }

  fun updateCustomTokenTransaction (
    senderAddress : String,
    senderPublicKey : String,
    name : String,
    amount : String,
    speed : String
  ) : Transaction {
    {
      id = "",
      action = "update_token",
      senders =
        [
          {
            address = senderAddress,
            publicKey = senderPublicKey,
            amount = amount,
            fee = "0.0001",
            signature = "0"
          }
        ],
      recipients =
        [
          {
            address = senderAddress,
            amount = amount
          }
        ],
      message = "0",
      token = name,
      prevHash = "0",
      timestamp = 0,
      scaled = 0,
      kind = speed,
      version = "V1"
    }
  }

  fun lockCustomTokenTransaction (
    senderAddress : String,
    senderPublicKey : String,
    name : String,
    speed : String
  ) : Transaction {
    {
      id = "",
      action = "lock_token",
      senders =
        [
          {
            address = senderAddress,
            publicKey = senderPublicKey,
            amount = "0",
            fee = "0.0001",
            signature = "0"
          }
        ],
      recipients =
        [
          {
            address = senderAddress,
            amount = "0"
          }
        ],
      message = "0",
      token = name,
      prevHash = "0",
      timestamp = 0,
      scaled = 0,
      kind = speed,
      version = "V1"
    }
  }

  fun burnCustomTokenTransaction (
    senderAddress : String,
    senderPublicKey : String,
    name : String,
    amount : String,
    speed : String
  ) : Transaction {
    {
      id = "",
      action = "burn_token",
      senders =
        [
          {
            address = senderAddress,
            publicKey = senderPublicKey,
            amount = amount,
            fee = "0.0001",
            signature = "0"
          }
        ],
      recipients =
        [
          {
            address = senderAddress,
            amount = amount
          }
        ],
      message = "0",
      token = name,
      prevHash = "0",
      timestamp = 0,
      scaled = 0,
      kind = speed,
      version = "V1"
    }
  }
}
