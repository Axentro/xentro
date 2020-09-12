component Login {
  connect WalletStore exposing { getWallet, currentWallet, getSavedWalletOptions, currentWalletConfig }
  connect Application exposing { updateWebSocketConnect, updateMinerWebSocketConnect, webSocket }

  state password : String = ""
  state walletName : String = ""
  state walletOptions : Array(String) = []
  state loginError : String = ""

  fun componentDidMount : Promise(Never, Void) {
    sequence {
      saved =
        getSavedWalletOptions()
        |> Result.withDefault([])

      firstName =
        Array.first(saved)
        |> Maybe.withDefault("")

      next
        {
          walletOptions = saved,
          walletName = firstName
        }

      LayoutHelper.preLoad()
    }
  }

  fun onPassword (event : Html.Event) : Promise(Never, Void) {
    next
      {
        password = Dom.getValue(event.target),
        loginError = ""
      }
  }

  fun onName (event : Html.Event) : Promise(Never, Void) {
    next
      {
        walletName = Dom.getValue(event.target),
        loginError = ""
      }
  }

  get createButtonState : Bool {
    String.isEmpty(password)
  }

  fun login (event : Html.Event) : Promise(Never, Void) {
    sequence {
      getWallet(walletName, password)

      if (Maybe.isNothing(currentWallet)) {
        next { loginError = "The credentials you supplied were incorrect!" }
      } else {
        sequence {
          updateWebSocketConnect(currentWalletConfig.node)
          updateMinerWebSocketConnect(currentWalletConfig.node)
          Window.navigate("/dashboard")
        }
      }
    }
  }

  fun renderForm : Html {
    <div>
      <div>
        <h5>
          "Login Wallet"
        </h5>

        <{ UiHelper.errorAlert(loginError) }>

        <div class="text-left form-group">
          <label
            class="ml-1"
            for="walletName">

            <i>
              "Wallet name"
            </i>

          </label>

          <select
            onChange={onName}
            class="form-control"
            id="walletName">

            <{ UiHelper.selectNameOptions(walletName, walletOptions) }>

          </select>
        </div>

        <div class="text-left form-group">
          <label
            class="ml-1"
            for="password">

            <i>
              "Password"
            </i>

          </label>

          <div class="input-group mb-3">
            <input
              onInput={onPassword}
              type="password"
              class="form-control"
              id="password"
              placeholder="Password"
              maxLength="100"/>
          </div>
        </div>

        <button
          type="submit"
          class="btn btn-primary"
          onClick={login}
          disabled={createButtonState}>

          "Login"

        </button>
      </div>

      <hr/>

      <{ noWallet() }>
    </div>
  }

  fun noWallet : Html {
    <div>
      <p class="text-muted">
        "Don't have a wallet?"
      </p>

      <a
        href="/register"
        class="btn btn-outline-light btn-sm">

        "Create a wallet here"

      </a>
    </div>
  }

  fun formOrNoWallet : Html {
    if (Array.isEmpty(walletOptions)) {
      noWallet()
    } else {
      renderForm()
    }
  }

  fun render : Html {
    <div class="form-membership">
      <div class="form-wrapper">
        <div id="logo">
          <img
            class="logo"
            src="/assets/media/image/axentro-logo-v.png"
            width="150"
            alt="logo"/>
        </div>

        <{ formOrNoWallet() }>
      </div>
    </div>
  }
}
