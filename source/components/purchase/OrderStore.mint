store OrderStore {

 state orders : Array(OrdersResponse) = []
 state sendError : String = ""

 fun resetSendError : Promise(Never,Void) {
     next { sendError = ""}
 }

 fun setSendError(error : String) : Promise(Never, Void) {
     next { sendError = error}
 }

 fun toHash(data : String) : String {
   `all_crypto.cryptojs.SHA256(#{data}).toString()`
 }

  fun signPrivateSale (
    hash : String,
    hexPrivateKey : String
  ) : Result(Wallet.Error, String) {
    `
    (() => {
      try {
        
        var signature = sign(#{hexPrivateKey}, #{hash});
       
        return #{Result::Ok(`signature`)}
      } catch (e) {
        return  #{Result::Err(Wallet.Error::SigningError)}
      }
    })()
    `
  } 
  
  fun fetchOrders(senderAddress : String, currentWalletConfig : WalletConfig, currentWallet : Maybe(Wallet)) {
    sequence {


       hexPrivateKey =
                      currentWallet 
                      |> Maybe.map((w : Wallet) { Axentro.Wallet.getPrivateKeyFromWif(w.wif) |> Result.withDefault("error") })
                      |> Maybe.withDefault("error")
        

      publicKey = currentWallet
                  |> Maybe.map((w : Wallet) { w.publicKey })
                  |> Maybe.withDefault("error")


      data = senderAddress + publicKey
      hash = toHash(data)
      signature = signPrivateSale(hash, hexPrivateKey)

      payload = { address = senderAddress, publicKey = publicKey, hash = hash, signature = signature}   
      
      requestBody = encode { call = "private_sale", action = "address_orders", payload = payload }
      baseUrl = currentWalletConfig.node

      response =
        Http.post(baseUrl + "/rpc")
        |> Http.jsonBody(requestBody)
        |> Http.send()

        json = 
          Json.parse(response.body)
          |> Maybe.toResult("Json parsing error with fetch orders")

        result =
          decode json as Array(OrdersResponse)

      if (response.status == 200) {
           next { orders = result }
      } else {
        next { sendError = "Could not fetch orders"  } 
      }
    } catch {
        next { sendError = "Could not fetch orders" } 
    }
  } 
}