component Layout {
  connect Application exposing { dataError }
  property content : Array(Html) = []
  property navigation : Array(Html) = []

  fun componentDidMount : Promise(Never, Void) {
    sequence {
     LayoutHelper.preLoad()
     LayoutHelper.feedback()
    }
  }

  fun render : Html {
    <div>
      <div class="layout-wrapper">
        <div class="header d-print-none">
          <div class="header-left">
            <div class="header-logo">
              <a href="/dashboard">
                <img
                  class="logo"
                  src="/assets/media/image/axentro-logo-h.svg"
                  width="150"
                  alt="logo"/>
                  <span style="margin-left:6px;padding-top:12px;"><Version/></span>
              </a>
            </div>
          </div>

          <{ navigation }>
        </div>

        <div class="content-wrapper">
          <div class="content-body">
            <div class="content">
              <div class="page-header"/>
              <{ dataError }>
              <{ content }>
              <a href="https://axentrowalletfeedback.loopinput.com/5f5c9ab7e70b0600173624d3 "target="_blank" id="feedbackButton">"Have a Suggestion?"</a>

              
            </div>
          </div>
        </div>
      </div>
    </div>
  }
}
