record Ui.Pager.Item {
  contents : Html,
  name : String
}

record WalletWebSocketMessage {
  address : String
}

record Token {
  name : String,
  amount : String
}

record RecentTransaction {
  transactionId : String using "transaction_id",
  kind : String,
  from : String,
  fromReadable : String using "from_readable",
  to : String,
  toReadable : String using "to_readable",
  amount : String,
  token : String,
  category : String,
  datetime : String,
  status : String,
  direction : String
}

record RejectedTransaction {
  transactionId : String
}

record WalletInfo {
  address : String,
  readable : Array(String),
  tokens : Array(Token),
  recentTransactions : Array(RecentTransaction) using "recent_transactions",
  rejectedTransactions : Array(RejectedTransaction) using "rejected_transactions"
}

component Main {
  connect Application exposing { page, setLog, setDataError, setWalletInfo }

  use Provider.WebSocket {
    url = "ws://localhost:3001/wallet_info",
    onMessage = handleMessage,
    onError = handleError,
    onClose = handleClose,
    onOpen = handleOpen
  }

  fun handleClose : Promise(Never, Void) {
    setLog("Closed...")
  }

  fun handleError : Promise(Never, Void) {
    setLog("Errored...")
  }

  fun handleOpen (socket : WebSocket) : Promise(Never, Void) {
    sequence {
      setLog("Opened...")

      message =
        { address = "VDA2NjU5N2JlNDA3ZDk5Nzg4MGY2NjY5YjhhOTUwZTE2M2VmNjM5OWM2M2EyMWQz" }

      json =
        encode message

      WebSocket.send(Json.stringify(json), socket)

      setLog("Sent some data...")
    }
  }

  fun handleMessage (data : String) : Promise(Never, Void) {
    sequence {
      `console.log('message received')`

      json =
        Json.parse(data)
        |> Maybe.toResult("Json parsing error")

      walletInfo =
        decode json as WalletInfo

      setWalletInfo(walletInfo)

      setDataError("")
    } catch String => er {
      setDataError("Could not parse json response")
    } catch Object.Error => er {
      setDataError("Could not decode json")
    }
  }

  get pages : Array(Ui.Pager.Item) {
    [
      {
        name = "dashboard",
        contents = <Dashboard/>
      },
      {
        name = "send",
        contents = <Send/>
      },
      {
        name = "receive",
        contents = <Receive/>
      },
      {
        name = "tools",
        contents = <Tools/>
      },
      {
        name = "not_found",
        contents =
          <div>
            "404"
          </div>
      }
    ]
  }

  fun preloader (contents : Html) : Html {
    <div>
      <div
        id="preloader"
        class="preloader">

        <div class="preloader-icon"/>

      </div>

      <{ contents }>
    </div>
  }

  fun render : Html {
    pages
    |> Array.find(
      (item : Ui.Pager.Item) : Bool { item.name == page })
    |> Maybe.map(
      (item : Ui.Pager.Item) : Html { preloader(item.contents) })
    |> Maybe.withDefault(<div/>)
  }
}
