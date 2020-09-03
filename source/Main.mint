record Ui.Pager.Item {
  contents : Html,
  name : String
}

record WalletWebSocketMessage {
  address : String
}

record MinerMessage {
  type : Number,
  content : String
}

record MinerRejectedMessage {
  reason : String
}

record MinerHandshakeMessage {
  version : Number,
  address : String,
  mid : String
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
  transactionId : String using "transaction_id",
  senderAddress : String using "sender_address",
  rejectionReason : String using "rejection_reason",
  datetime : String,
  status : String
}

record WalletInfo {
  address : String,
  readable : Array(String),
  tokens : Array(Token),
  recentTransactions : Array(RecentTransaction) using "recent_transactions",
  rejectedTransactions : Array(RejectedTransaction) using "rejected_transactions"
}

enum ConnectionStatus {
  Initial
  Connected
  Disconnected
  Error
  Receiving
}

component Main {
  connect Application exposing {
    page,
    setDataError,
    setWalletInfo,
    walletInfo,
    setWebSocket,
    webSocket,
    setMinerWebSocket,
    minerWebSocket,
    setConnectionstatus,
    setMinerConnectionstatus,
    shouldWebSocketConnect,
    shouldMinerWebSocketConnect,
    webSocketUrl,
    minerWebSocketUrl,
    numberProcesses
  }

  connect WalletStore exposing { currentWallet }
 
  use Provider.WebSocket {
    url = webSocketUrl,
    onMessage = handleMessage,
    onError = handleError,
    onClose = handleClose,
    onOpen = handleOpen
  } when {
    shouldWebSocketConnect
  }

   use Provider.MinerWebSocket {
    url = minerWebSocketUrl,
    onMessage = handleMinerMessage,
    onError = handleMinerError,
    onClose = handleMinerClose,
    onOpen = handleMinerOpen
  } when {
    shouldMinerWebSocketConnect
  }

   fun handleMinerOpen (socket : WebSocket) : Promise(Never, Void) {
    sequence {
      `console.log('Miner handleOpen' + #{numberProcesses})`

      setMinerWebSocket(socket)
      setMinerConnectionstatus(ConnectionStatus::Connected)

      currentWallet
      |> Maybe.map(
        (cw : Wallet) {
          minerWebSocket
          |> Maybe.map((s : WebSocket) { NodeHelper.minerHandshake(s, cw.address) })
        })

      Promise.never()
    }
  }

  fun handleMinerClose : Promise(Never, Void) {
    sequence {
      `console.log('Miner handleClose ' + #{numberProcesses})`
       setMinerConnectionstatus(ConnectionStatus::Disconnected)
    }
  }

  fun handleMinerError : Promise(Never, Void) {
    sequence {
      `console.log('Miner handleError ' + #{numberProcesses})`
      setMinerConnectionstatus(ConnectionStatus::Error)
    }
  }

  fun handleMinerMessage (data : String) : Promise(Never, Void) {
    sequence {
      `console.log('Miner message received: ' + #{data})`

      json =
        Json.parse(data)
        |> Maybe.toResult("Json parsing error") 

       minerMessage =
        decode json as MinerMessage

        Debug.log(minerMessage.type)

        if(minerMessage.type == MinerConnection:HANDSHAKE_ACCEPTED) {
           handshakeAccepted()
        } else if (minerMessage.type == MinerConnection:HANDSHAKE_REJECTED) {
           handshakeRejected(minerMessage)
        } else {
         all() 
        }
      
      setDataError("")
    } catch String => er {
      setDataError("Could not parse handleMinerMessage json response")
    } catch Object.Error => er {
      setDataError("Could not decode handleMinerMessage json")
    }
  }

  fun handshakeAccepted() : Promise(Never,Void) {
    sequence {
    Debug.log("ACCEPTED - start miner threads")
    Promise.never()
    }
  }

  fun handshakeRejected(minerMessage : MinerMessage) : Promise(Never, Void) {
    sequence {

      json =
        Json.parse(minerMessage.content)
        |> Maybe.toResult("Json parsing error") 

       content =
        decode json as MinerRejectedMessage

      setDataError(content.reason)
    } catch String => er {
      setDataError("Could not parse handshakeRejected json response")
    } catch Object.Error => er {
      setDataError("Could not decode handshakeRejected json")
    }
  }

  fun all() : Promise(Never,Void) {
    Promise.never()
  }



  fun getWalletInfo {
    sequence {
      currentWallet
      |> Maybe.map(
        (cw : Wallet) {
          webSocket
          |> Maybe.map((s : WebSocket) { NodeHelper.sendMessage(s, cw) })
        })

      Promise.never()
    }
  }

  fun handleOpen (socket : WebSocket) : Promise(Never, Void) {
    sequence {
      `console.log('handleOpen')`
      setWebSocket(socket)
      setConnectionstatus(ConnectionStatus::Connected)

      getWalletInfo()
    }
  }

  fun handleClose : Promise(Never, Void) {
    sequence {
      `console.log('handleClose error')`
      setConnectionstatus(ConnectionStatus::Disconnected)
    }
  }

  fun handleError : Promise(Never, Void) {
    sequence {
      `console.log('handleError error')`
      setConnectionstatus(ConnectionStatus::Error)
    }
  }

  fun handleMessage (data : String) : Promise(Never, Void) {
    sequence {
      `console.log('message received: ' + #{data})`
      setConnectionstatus(ConnectionStatus::Receiving)
      Timer.timeout(500, setConnectionstatus(ConnectionStatus::Connected))

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
        name = "settings",
        contents = <Settings/>
      },
      {
        name = "address",
        contents = <Address/>
      },
      {
        name = "login",
        contents = <Login/>
      },
      {
        name = "register",
        contents = <Register/>
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
