enum NodeEnv {
  MainNet
  TestNet
  Local
}

module NodeHelper {
  fun webSocketUrl (url : String) : String {
    try {
      parsed =
        Url.parse(url)

      Debug.log("PROTOCOL")
      Debug.log(parsed.protocol)

      protocol =
        if (parsed.protocol == "https:") {
          "wss://"
        } else {
          "ws://"
        }

      protocol + parsed.host + "/wallet_info"
    }
  }

  fun minerWebSocketUrl (url : String) : String {
    try {
      parsed =
        Url.parse(url)

      protocol =
        if (parsed.protocol == "https:") {
          "wss://"
        } else {
          "ws://"
        }

      protocol + parsed.host + "/peer"
    }
  }

  fun isDomain (value : String) : Bool {
    `#{value}.slice(-3)` == ".ax"
  }

  fun nodeEnv (url : String) : NodeEnv {
    try {
      parsed =
        Url.parse(url)

      parts =
        String.split(".", parsed.host)

      if (Array.contains("testnet", parts)) {
        NodeEnv::TestNet
      } else if (Array.contains("mainnet", parts)) {
        NodeEnv::MainNet
      } else {
        NodeEnv::Local
      }
    }
  }

  fun sendMessage (socket : WebSocket, wallet : Wallet) : Promise(Never, Void) {
    sequence {
      `console.log('sending message ...')`

      message =
        { address = wallet.address }

      json =
        encode message

      WebSocket.send(Json.stringify(json), socket)
    }
  }

  fun minerHandshake (socket : WebSocket, address : String) : Promise(Never, Void) {
    sequence {
      `console.log('miner handshake init ...')`

      content =
        {
          version = 1,
          mid = "535061bddb0549f691c8b9c012a55ee2",
          address = address
        }

      contentJson =
        encode content

      message =
        {
          type = 1,
          content = Json.stringify(contentJson)
        }

      json =
        encode message

      WebSocket.send(Json.stringify(json), socket)
    }
  }
}
