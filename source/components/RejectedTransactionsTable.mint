component RejectedTransactionsTable {
  property tableId : String = "rejected-transactions"
  property headerRow : Array(String) = ["Date", "Id", "From", "Reason", "Status"]
  property rows : Array(RejectedTransaction) = []

  fun trunc (value : String, length : Number) : String {
    `#{value}.substring(0,#{length})`
  }

  fun renderAddress (address : String) : String {
    trunc(address, 7)
  }

  fun renderStatus (status : String) : Html {
    <span class={"badge " + colour}>
      <{ status }>
    </span>
  } where {
    colour =
      if (status == "Completed") {
        "bg-success-bright"
      } else {
        "bg-warning"
      }
  }

  fun renderBodyRow (row : RejectedTransaction) : Html {
    <tr>
      <td>
        <{ row.datetime }>
      </td>

      <td>
        <{ trunc(row.transactionId, 8) }>
      </td>

      <td>
        <{ renderAddress(row.senderAddress) }>
      </td>

      <td>
        <{ row.rejectionReason }>
      </td>

      <td>
        <{ renderStatus(row.status) }>
      </td>
    </tr>
  }

  fun render : Html {
    if (Array.isEmpty(rows)) {
      renderNoRows()
    } else {
      renderTable()
    }
  }

  fun renderNoRows : Html {
    <p>"No transactions have been sent yet!"</p>
  }

  fun renderTable : Html {
    <div
      class="card-scroll"
      style="height:500px;">

      <div class="table-responsive">
        <table
          id={tableId}
          class="table table-striped table-bordered">

          <thead>
            <tr>
              for (header of headerRow) {
                <th>
                  <{ header }>
                </th>
              }
            </tr>
          </thead>

          <tbody>
            for (row of rows) {
              renderBodyRow(row)
            }
          </tbody>

        </table>
      </div>

    </div>
  }
}
