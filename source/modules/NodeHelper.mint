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

      "ws://" + parsed.host + "/wallet_info"
    }
  }

  fun isDomain (value : String) : Bool {
    `#{value}.slice(-3)` == ".sc"
  }

  fun nodeEnv (url : String) : NodeEnv {
    try {
      parts =
        String.split("", url)

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
}
