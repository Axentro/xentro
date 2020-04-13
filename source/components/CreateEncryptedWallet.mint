record PasswordStrength {
  score : Number,
  warning : String,
  suggestions : Array(String)
}

record ScoreInfo {
  text : String,
  colour : String
}

enum PasswordStrength.Error {
  PasswordStrengthError
}

record EncryptedWalletWithName {
  name : String,
  source : String,
  ciphertext : String,
  address : String,
  salt : String
}

component CreateEncryptedWallet {
  connect WalletStore exposing { storeWallet, walletError }

  property cancelUrl : String = "/"

  state name : String = ""
  state password : String = ""
  state repeatPassword : String = ""

  state passwordStrength : PasswordStrength = {
    score = -1,
    warning = "",
    suggestions = []
  }

  state showPassword : Bool = false
  state showRepeatPassword : Bool = false

  state passwordError : String = ""

  style spacer {
    padding-left: 10px;
  }

  style height {
    margin-top: 5px;
  }

  style italics {
    font-style: italic;
  }

  style pointer {
    cursor: pointer;
  }

  fun onName (event : Html.Event) : Promise(Never, Void) {
    next { name = Dom.getValue(event.target) }
  }

  fun getPasswordStrength (password : String) : Result(PasswordStrength.Error, PasswordStrength) {
    `
    (() => {
      try {
        var result = zxcvbn(#{password});
        return new Ok(new Record({score: result.score, warning: result.feedback.warning, suggestions: result.feedback.suggestions}))
      } catch (e) {
        return new Err(#{PasswordStrength.Error::PasswordStrengthError})
      }
    })()
    `
  }

  fun onPassword (event : Html.Event) : Promise(Never, Void) {
    try {
      pass =
        Dom.getValue(event.target)

      strength =
        getPasswordStrength(pass)

      if (String.isEmpty(pass)) {
        next
          {
            password = pass,
            passwordStrength =
              {
                score = -1,
                warning = "",
                suggestions = []
              }
          }
      } else {
        next
          {
            password = pass,
            passwordStrength = strength
          }
      }
    } catch PasswordStrength.Error => error {
      sequence {
        next
          {
            passwordStrength =
              {
                score = -1,
                warning = "",
                suggestions = []
              }
          }

        next { passwordError = "Password strength checking error" }
      }
    }
  }

  fun onRepeatPasssword (event : Html.Event) : Promise(Never, Void) {
    next { repeatPassword = Dom.getValue(event.target) }
  }

  fun togglePasswordVisibility (event : Html.Event) : Promise(Never, Void) {
    next { showPassword = !showPassword }
  }

  fun toggleRepeatPasswordVisibility (event : Html.Event) : Promise(Never, Void) {
    next { showRepeatPassword = !showRepeatPassword }
  }

  fun createWallet (event : Html.Event) : Promise(Never, Void) {
    try {
      wallet =
        Sushi.Wallet.generateEncryptedWallet(Network.Prefix.testNet(), name, password)

      storeWallet(wallet)

      Window.navigate("/login")
    } catch Wallet.Error => error {
      next { passwordError = "Could not generate a new wallet" }
    }
  }

  fun scoreText (score : Number) : ScoreInfo {
    case (score) {
      0 =>
        {
          text = "Worst",
          colour = "danger"
        }

      1 =>
        {
          text = "Bad",
          colour = "danger"
        }

      2 =>
        {
          text = "Weak",
          colour = "warning"
        }

      3 =>
        {
          text = "Good",
          colour = "success"
        }

      4 =>
        {
          text = "Strong",
          colour = "success"
        }

      =>
        {
          text = "Worst",
          colour = "danger"
        }
    }
  }

  get showPasswordStrength : Html {
    try {
      strength =
        passwordStrength

      score =
        Number.toString(strength.score)

      warning =
        strength.warning

      suggestions =
        String.join(" , ", strength.suggestions)

      rating =
        scoreText(strength.score)

      if (strength.score == -1) {
        <div/>
      } else {
        <div::height>
          <div class={"alert alert-" + rating.colour}>
            <span>
              "Strength: "
            </span>

            <strong>
              <{ rating.text + " " }>
            </strong>

            <span::italics>
              <{ warning }>
            </span>

            <span::italics>
              <{ " " + suggestions }>
            </span>
          </div>
        </div>
      }
    }
  }

  get passwordsNotMatchingAlert : Html {
    if (String.isEmpty(password) && String.isEmpty(repeatPassword)) {
      <div/>
    } else if (password == repeatPassword) {
      <div/>
    } else if (String.isEmpty(repeatPassword) || String.isEmpty(password)) {
      <div/>
    } else {
      <div::height>
        <div class="alert alert-danger">
          "The password and repeat password you entered do not matc" \
          "h"
        </div>
      </div>
    }
  }

  get createButtonState : Bool {
    (String.isEmpty(name) || String.isEmpty(password) || String.isEmpty(repeatPassword)) || (password != repeatPassword)
  }

  fun checkMark (colour : String, icon : String) : Html {
    <div class="input-group-prepend">
      <span
        class="input-group-text"
        id="basic-addon3">

        <i class={"fa fa-" + icon + " text-" + colour}/>

      </span>
    </div>
  }

  get checkIndicator : Html {
    if (String.isEmpty(password) && String.isEmpty(repeatPassword)) {
      <div/>
    } else if (password == repeatPassword) {
      checkMark("success", "check")
    } else if (String.isEmpty(repeatPassword) || String.isEmpty(password)) {
      <div/>
    } else {
      checkMark("danger", "times")
    }
  }

  get passwordType : String {
    if (showPassword) {
      "text"
    } else {
      "password"
    }
  }

  get repeatPasswordType : String {
    if (showRepeatPassword) {
      "text"
    } else {
      "password"
    }
  }

  get passwordEye : String {
    if (showPassword) {
      "eye-slash"
    } else {
      "eye"
    }
  }

  get repeatPasswordEye : String {
    if (showRepeatPassword) {
      "eye-slash"
    } else {
      "eye"
    }
  }

  fun cancel (event : Html.Event) : Promise(Never, Void) {
    Window.navigate(cancelUrl)
  }

  fun render : Html {
    <div>
      <h5>
        "Create Wallet"
      </h5>

      <div class="text-left form-group">
        <label
          class="ml-1"
          for="walletName">

          <i>
            "Wallet name"
          </i>

        </label>

        <input
          onInput={onName}
          type="text"
          class="form-control"
          id="walletName"
          aria-describedby="walletName"
          maxLength="100"
          placeholder="Enter a name for this wallet"/>
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
          <{ checkIndicator }>

          <input
            onInput={onPassword}
            type={passwordType}
            class="form-control"
            id="password"
            placeholder="Password"
            maxLength="100"
            aria-describedby="basic-addon2"/>

          <div class="input-group-append">
            <span
              class="input-group-text"
              id="basic-addon2">

              <span::pointer>
                <i
                  onClick={togglePasswordVisibility}
                  class={"fa fa-" + passwordEye}/>
              </span>

            </span>
          </div>
        </div>

        <{ showPasswordStrength }>
      </div>

      <div class="text-left form-group">
        <label
          class="ml-1"
          for="password">

          <i>
            "Repeat Password"
          </i>

        </label>

        <div class="input-group mb-3">
          <{ checkIndicator }>

          <input
            onInput={onRepeatPasssword}
            type={repeatPasswordType}
            class="form-control"
            id="repeatPassword"
            placeholder="Repeat password"
            maxLength="100"
            aria-describedby="basic-addon2"/>

          <div class="input-group-append">
            <span
              class="input-group-text"
              id="basic-addon2">

              <span::pointer>
                <i
                  onClick={toggleRepeatPasswordVisibility}
                  class={"fa fa-" + repeatPasswordEye}/>
              </span>

            </span>
          </div>
        </div>

        <{ passwordsNotMatchingAlert }>
      </div>

      <button
        onClick={cancel}
        class="btn btn-outline-primary">

        "Cancel"

      </button>

      <span::spacer/>

      <button
        type="submit"
        class="btn btn-primary"
        onClick={createWallet}
        disabled={createButtonState}>

        "Create"

      </button>
    </div>
  }
}
