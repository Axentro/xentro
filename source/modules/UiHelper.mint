module UiHelper {
  fun errorAlert (error : String) : Html {
    if (String.isEmpty(error)) {
      <div/>
    } else {
      <div
        class="alert alert_style1 alert-danger"
        role="alert">

        <i class="ion-close-circled"/>
        <{ error }>

      </div>
    }
  }

  fun successAlert (message : String) : Html {
    if (String.isEmpty(message)) {
      <div/>
    } else {
      <div
        class="alert alert_style1 alert-success"
        role="alert">

        <i class="ti-thumb-up"/>
        <{ message }>

      </div>
    }
  }

  fun submitOnEnter (
    event : Html.Event,
    callback : Function(Html.Event, Promise(Never, Void))
  ) : Promise(Never, Void) {
    if (event.charCode == 13) {
      callback(event)
    } else {
      Promise.never()
    }
  }

  fun selectNameOptions (selectedName : String, options : Array(String)) : Array(Html) {
    options
    |> Array.map(
      (opt : String) : Html { renderSelectOption(opt, selectedName) })
  }

  fun renderSelectOption (opt : String, currentlySelected : String) : Html {
    if (opt == currentlySelected) {
      <option
        value={opt}
        selected="true">

        <{ opt }>

      </option>
    } else {
      <option value={opt}>
        <{ opt }>
      </option>
    }
  }
}
