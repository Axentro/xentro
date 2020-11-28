component Register {
  fun componentDidMount : Promise(Never, Void) {
    LayoutHelper.preLoad()
  }

  fun render {
    <div class="form-membership">
      <div class="form-wrapper">
        <div id="logo">
          <img
            class="logo"
            src="/assets/media/image/axentro-logo-v.png"
            width="150"
            alt="logo"/>

          <Version/>
        </div>

        <div>
          <CreateEncryptedWallet/>
          <hr/>

          <p class="text-muted">
            "Already have a wallet?"
          </p>

          <a
            href="/login"
            class="btn btn-outline-light btn-sm">

            "Login here"

          </a>
        </div>
      </div>
    </div>
  }
}
