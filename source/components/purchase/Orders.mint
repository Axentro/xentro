record OrdersResponse {
  id : String,
  timestamp : String,
  referral : String,
  tokenAmount : String using "token_amount",
  amount : String,
  paymentMethod : String using "payment_method",
  transactionId : String using "transaction_id",
  agree : String,
  status : String
}

record OrderUpdateRequest {
  id : String,
  transactionId : String using "transaction_id",
  publicKey : String using "public_key",
  hash : String,
  signature : String
}

record GetOrdersRequest {
  address : String,
  publicKey : String using "public_key",
  hash : String,
  signature : String
}

component Orders {
  connect WalletStore exposing { currentWallet, currentWalletConfig }
  connect OrderStore exposing { fetchOrders, sendError, toHash, signPrivateSale, orders }

  property senderAddress : String
  state selectedOrder : String = "Choose"
  state transactionId : String = ""
  state updateError : String = ""
  state myReferralCode : String = ""

  fun componentDidMount : Promise(Never, Void) {
    sequence {
      fetchOrders(senderAddress, currentWalletConfig, currentWallet)
      fetchReferralCode(senderAddress, currentWalletConfig, currentWallet)
    }
  }

  fun onOrderId (event : Html.Event) {
    next
      {
        selectedOrder = Dom.getValue(event.target),
        updateError = ""
      }
  }

  fun onTransactionId (event : Html.Event) {
    next
      {
        transactionId = Dom.getValue(event.target),
        updateError = ""
      }
  }

  fun render : Html {
    if (Array.isEmpty(orders)) {
      <div/>
    } else {
      renderOrders()
    }
  }

  fun renderOrderRow (order : OrdersResponse) : Html {
    <tr>
      <td>
        <{ order.id }>
      </td>

      <td>
        <{ order.timestamp }>
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
            <th>"Order Id"</th>
            <th>"Timestamp"</th>
            <th>"Token amount"</th>
            <th>"Amount"</th>
            <th>"Payment method"</th>
            <th>"Referral code"</th>
            <th>"Transaction Id"</th>
            <th>"Status"</th>
          </tr>
        </thead>

        <tbody>
          for (order of orders) {
            renderOrderRow(order)
          }
        </tbody>

      </table>
    </div>
  }

  get renderMyReferralCode : Html {
    if (String.isEmpty(myReferralCode)) {
      <div/>
    } else {
      <div
        class="alert alert-primary alert-with-border"
        role="alert">

        <p>
          "Your referral code is: "

          <b>
            <{ myReferralCode }>
          </b>

          "   ("
          <i>"Give this to your friends to earn a 10% bonus"</i>
          ")"
        </p>

      </div>
    }
  }

  fun renderOrders : Html {
    <div class="card border-dark mb-3">
      <div class="card-body">
        <h4 class="card-title">
          "Orders"
        </h4>

        <{ UiHelper.errorAlert(sendError) }>
        <{ UiHelper.errorAlert(updateError) }>

        <div
          class="alert alert-warning alert-with-border"
          role="alert">

          <p>
            "Please transfer "
            <b>"ETH"</b>
            " to this address:"
            <b>"0xce333B095774b0868Bc64e7F43B5e591EE834a3B"</b>
          </p>

          <p>
            "Please transfer "
            <b>"BTC"</b>
            " to this address: "
            <b>"31nueJVFz8SjxhLwUp8LsbuWe9Y3Km4Fh8"</b>
          </p>

        </div>

        <{ renderMyReferralCode }>

        <{ orderTable }>
        <{ updateOrderForm() }>
      </div>
    </div>
  }

  fun updateOrderForm : Html {
    if (Array.isEmpty(statuses)) {
      <div/>
    } else {
      renderUpdateForm()
    }
  } where {
    statuses =
      orders
      |> Array.select((o : OrdersResponse) { o.status == "awaiting payment" })
  }

  get validateUpdateButton : Bool {
    selectedOrder == "Choose" || String.isEmpty(transactionId)
  }

  fun fetchReferralCode (
    senderAddress : String,
    currentWalletConfig : WalletConfig,
    currentWallet : Maybe(Wallet)
  ) {
    sequence {
      hexPrivateKey =
        currentWallet
        |> Maybe.map(
          (w : Wallet) {
            Axentro.Wallet.getPrivateKeyFromWif(w.wif)
            |> Result.withDefault("error")
          })
        |> Maybe.withDefault("error")

      publicKey =
        currentWallet
        |> Maybe.map((w : Wallet) { w.publicKey })
        |> Maybe.withDefault("error")

      data =
        senderAddress + publicKey

      hash =
        toHash(data)

      signature =
        signPrivateSale(hash, hexPrivateKey)

      payload =
        {
          address = senderAddress,
          publicKey = publicKey,
          hash = hash,
          signature = signature
        }

      requestBody =
        encode {
          call = "private_sale",
          action = "my_referral_code",
          payload = payload
        }

      baseUrl =
        currentWalletConfig.node

      response =
        Http.post(baseUrl + "/rpc")
        |> Http.jsonBody(requestBody)
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error with fetch orders")

      result =
        decode json as Array(String)

      if (response.status == 200) {
        next { myReferralCode = Array.firstWithDefault("", result) }
      } else {
        Promise.never()
      }
    } catch {
      Promise.never()
    }
  }

  fun postUpdateOrder (event : Html.Event) {
    sequence {
      hexPrivateKey =
        currentWallet
        |> Maybe.map(
          (w : Wallet) {
            Axentro.Wallet.getPrivateKeyFromWif(w.wif)
            |> Result.withDefault("error")
          })
        |> Maybe.withDefault("error")

      publicKey =
        currentWallet
        |> Maybe.map((w : Wallet) { w.publicKey })
        |> Maybe.withDefault("error")

      data =
        senderAddress + selectedOrder + transactionId + publicKey

      hash =
        toHash(data)

      signature =
        signPrivateSale(hash, hexPrivateKey)

      payload =
        {
          id = selectedOrder,
          transactionId = transactionId,
          publicKey = publicKey,
          hash = hash,
          signature = signature
        }

      requestBody =
        encode {
          call = "private_sale",
          action = "update_order",
          payload = payload
        }

      baseUrl =
        currentWalletConfig.node

      response =
        Http.post(baseUrl + "/rpc")
        |> Http.jsonBody(requestBody)
        |> Http.send()

      if (response.status == 200) {
        sequence {
          next
            {
              selectedOrder = "Choose",
              transactionId = ""
            }

          fetchOrders(senderAddress, currentWalletConfig, currentWallet)
        }
      } else {
        next { updateError = "Unable to update order" }
      }
    } catch {
      next { updateError = "Unable to update order" }
    }
  }

  fun renderUpdateForm : Html {
    if (Array.isEmpty(orderIds)) {
      <div/>
    } else {
      <div>
        <hr/>
        <h4>"Update your order"</h4>
        <p>"Submit one or more transaction ids for your order using the form below."</p>

        <div class="form-group">
          <div class="col">
            <label for="order-to-update">
              "Order to update"
            </label>

            <select
              onChange={onOrderId}
              class="form-control"
              id="order-to-update">

              <{ UiHelper.selectNameOptions(selectedOrder, orderOptions) }>

            </select>
          </div>
        </div>

        <div class="form-group">
          <div class="col">
            <label for="transaction-update">
              "Your transaction Id"
            </label>

            <input
              type="text"
              class="form-control"
              id="transaction-update"
              placeholder="Transaction Id"
              onInput={onTransactionId}
              value={transactionId}/>
          </div>
        </div>

        <button
          class="btn btn-secondary"
          onClick={postUpdateOrder}
          disabled={validateUpdateButton}
          type="submit">

          "Update"

        </button>

        <br/>
        <br/>
      </div>
    }
  } where {
    orderIds =
      orders
      |> Array.select((o : OrdersResponse) { o.status == "awaiting payment" && o.paymentMethod != "Alternative" })
      |> Array.map((o : OrdersResponse) { o.id })

    orderOptions =
      Array.append(["Choose"], orderIds)
  }
}
