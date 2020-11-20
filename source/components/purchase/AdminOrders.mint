record AllOrdersResponse {
  id : String,
  timestamp : String,
  address : String, 
  referral : String,
  tokenAmount : String using "token_amount",
  amount : String,
  paymentMethod : String using "payment_method",
  transactionId : String using "transaction_id",
  status : String
}

record OrderStatusUpdateRequest {
  id : String,
  status : String,
  address : String,
  publicKey : String using "public_key",
  hash : String,
  signature : String
}

component AdminOrders {
  connect WalletStore exposing { currentWallet, currentWalletConfig }
  connect OrderStore exposing { toHash, signPrivateSale}

  property senderAddress : String
  state selectedOrder : String = "Choose"
  state transactionId : String = ""
  state updateError : String = ""
  state allOrders : Array(AllOrdersResponse) = []
  state selectedStatus : String = "Choose"

  fun componentDidMount : Promise(Never, Void) {
      fetchAllOrders(senderAddress, currentWalletConfig, currentWallet)
  }
  
   fun onOrderId (event : Html.Event) {
    next
      {
        selectedOrder = Dom.getValue(event.target), updateError = ""
      }
  
}

fun fetchAllOrders(senderAddress : String, currentWalletConfig : WalletConfig, currentWallet : Maybe(Wallet)) {
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
      
      requestBody = encode { call = "private_sale", action = "all_orders", payload = payload }
      baseUrl = currentWalletConfig.node

      response =
        Http.post(baseUrl + "/rpc")
        |> Http.jsonBody(requestBody)
        |> Http.send()

        json = 
          Json.parse(response.body)
          |> Maybe.toResult("Json parsing error with fetch orders")

        result =
          decode json as Array(AllOrdersResponse)

      if (response.status == 200) {
           next { allOrders = result }
      } else {
       Promise.never()
      }
    } catch {
       Promise.never()
    }
  } 


 fun onOrderStatus (event : Html.Event) {
    next
      {
        selectedStatus = Dom.getValue(event.target), updateError = ""
      }
  }

  fun render : Html {
      if (Array.isEmpty(allOrders)) {
        <div></div>
      } else {
        renderOrders()
      }
  }

  fun renderOrderRow(order : AllOrdersResponse) : Html {
       <tr>
      <td>
        <{ order.id }>
      </td>
       <td>
        <{ order.timestamp }>
      </td>
       <td>
        <{ order.address }>
      </td>
      <td>
        <{ order.tokenAmount }>
      </td>
      <td>
        <{ order.amount }>
      </td>
      <td>
        <{ order.paymentMethod }>
      </td>
      <td>
        <{ order.referral }>
      </td>
      <td>
        <{ order.transactionId }>
      </td>
      <td>
        <{ order.status }>
      </td>
      </tr>
  }

  get orderTable : Html {
         <div class="table-responsive">
        <table
          id="order-table"
          class="table table-striped table-bordered">

          <thead>
            <tr>
               <th>
                  "Order Id"
                </th>
                 <th>
                  "Timestamp"
                </th>
                <th>
                "Address"
                </th>
                  <th>
                "Token amount"
                </th> 
                <th>
                "Amount"
                </th>   
                <th>
                "Payment method"
                </th>
                <th>
                "Referral code"
                </th>
                <th>
                "Transaction Id"
                </th>
                <th>
                "Status"
                </th>
            </tr>
          </thead>

          <tbody>
              for (order of allOrders) {
              renderOrderRow(order)
            }
          </tbody>

        </table>
      </div>
  }

  fun renderOrders : Html {
       <div class="card border-dark mb-3">
      <div class="card-body">
        <h4 class="card-title">
          "Admin Orders"
        </h4>

     <{ UiHelper.errorAlert(updateError) }>


     <{ orderTable }>
    
     <{ updateOrderStatus() }>
      
      </div>
    </div>
  }

  fun updateOrderStatus() : Html {
    if (Array.isEmpty(statuses)) {
       <div></div>
    } else {
       renderUpdateStatus()
    }
  } where {
      statuses = allOrders 
                 |> Array.select((o : AllOrdersResponse) { o.status == "awaiting payment"})
  }

    get validateUpdateStatusButton : Bool {
    selectedOrder == "Choose" || selectedStatus == "Choose"
  }

 fun postUpdateStatus(event : Html.Event) {
    sequence {
      
       hexPrivateKey =
                      currentWallet 
                      |> Maybe.map((w : Wallet) { Axentro.Wallet.getPrivateKeyFromWif(w.wif) |> Result.withDefault("error") })
                      |> Maybe.withDefault("error")
        

      publicKey = currentWallet
                  |> Maybe.map((w : Wallet) { w.publicKey })
                  |> Maybe.withDefault("error")


      data = senderAddress + selectedOrder + selectedStatus + publicKey
      hash = toHash(data)
      signature = signPrivateSale(hash, hexPrivateKey)

      payload = {  id = selectedOrder, address = senderAddress, status = selectedStatus, publicKey = publicKey, hash = hash, signature = signature }

      requestBody = encode { call = "private_sale", action = "update_status", payload = payload }
      baseUrl = currentWalletConfig.node

      response =
        Http.post(baseUrl + "/rpc")
        |> Http.jsonBody(requestBody)
        |> Http.send()

      if (response.status == 200) {
        sequence {
          next { selectedOrder = "Choose", transactionId = "" }
          fetchAllOrders(senderAddress, currentWalletConfig, currentWallet)
        }
      } else {
        next { updateError = "Unable to update order" }
      }
    } catch {
        next { updateError = "Unable to update order" }
    }
  } 

  get statusOptions : Array(String) {
      ["awaiting payment", "verifying payment", "complete", "error"]
  }

  fun renderUpdateStatus() : Html {
    if (Array.isEmpty(orderIds)){
       <div></div>
    } else {
      <div>
      <hr/>

<div class="form-group">
              <div class="col">
              <label for="order-id-update">
                "Order status update"
              </label>

              <select
                onChange={onOrderId}
                class="form-control"
                id="order-id-update">

                <{ UiHelper.selectNameOptions(selectedOrder, orderOptions) }>

              </select>
            </div>
            </div>

<div class="form-group">
            <div class="col">
              <label for="transaction-update">
                "Order status"
              </label>

              <select
                onChange={onOrderStatus}
                class="form-control"
                id="order-status-update">

                <{ UiHelper.selectNameOptions(selectedStatus, statusOptions) }>

              </select>
            </div>
            </div>
          

          <button
            class="btn btn-secondary"
            onClick={postUpdateStatus}
            disabled={validateUpdateStatusButton}
            type="submit">

            "Update"

          </button>
          <br/><br/>
         
      </div>
    }
  } where {
      orderIds = allOrders
                 |> Array.map((o : AllOrdersResponse) { o.id })
      orderOptions = Array.append(["Choose"], orderIds)           
  }

 
}
