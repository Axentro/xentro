record Provider.WebSocket.Subscription {
  onOpen : Function(WebSocket, Promise(Never, Void)),
  onMessage : Function(String, Promise(Never, Void)),
  onError : Function(Promise(Never, Void)),
  onClose : Function(Promise(Never, Void)),
  url : String
}

provider Provider.WebSocket : Provider.WebSocket.Subscription {
  fun open (url : String, socket : WebSocket) : Array(a) {
    for (subscription of subscriptions) {
        subscription.onOpen(socket)
    } when {
      subscription.url == url
    }
  }

  fun message (url : String, data : String) : Array(a) {
    for (subscription of subscriptions) {
      subscription.onMessage(data)
    } when {
      subscription.url == url
    }
  }

  fun error (url : String) : Array(a) {
    for (subscription of subscriptions) {
      subscription.onError()
    } when {
      subscription.url == url
    }
  }

  fun close (url : String) : Array(a) {
    for (subscription of subscriptions) {
      subscription.onClose()
    } when {
      subscription.url == url
    }
  }

  fun clear (socket : WebSocket) {
    `
    (() => {
      let socket = #{socket};
      
      socket.removeEventListener("message", socket._message);
      socket.removeEventListener("error", socket._error);
      socket.removeEventListener("close", socket._close);
      socket.removeEventListener("open", socket._open);
      socket.close()
      
      this._connections.delete(socket.url)
    })()
    `
  }

  fun initialize (url : String) {
    `
    (() => {
      let socket = new WebSocket(#{url})
          
      this._connections.set(#{url}, socket)

      socket._message = (event) => #{message(url, `event.data`)}
      socket._error = () => #{error(url)}
      socket._open = () => #{open(url, `socket`)}

      socket._close = () => {
        #{close(url)}
        #{clear(`socket`)}
        #{initialize(url)}
      }

      socket.addEventListener("message", socket._message)
      socket.addEventListener("error", socket._error)
      socket.addEventListener("close", socket._close)
      socket.addEventListener("open", socket._open)
    })()
    `
  }

  fun update : Void {
    `
    (() => {
      window.provider = this;
      const connections = this._connections || (this._connections = new Map)
      const subscriptions = this.subscriptions.values()

      // create connections if not present
      for (let item of subscriptions) {
        if (!this._connections.has(item.url)) {
          #{initialize(`item.url`)}
        }
      }

      // drop connections that does not have subscriptions
      for (let item of this._connections) {
        const socket = item[1]
        const url = item[0]

        const subscriptionCount =
          #{subscriptions}.filter((subscription) => {
            return subscription.url === url
          }).length

        if (subscriptionCount == 0) {
          #{clear(`socket`)}
          socket.close()
        }
      }
    })()
    `
  }

  fun attach : Void {
    update()
  }

  fun detach : Void {
    update()
  }
}

module WebSocket {
  fun send (data : String, socket : WebSocket) : Promise(Never, Void) {
    `#{socket}.send(#{data})`
  }

  fun close (socket : WebSocket) : Promise(Never, Void) {
    `#{socket}.close()`
  }
}
