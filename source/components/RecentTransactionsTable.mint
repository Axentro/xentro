component RecentTransactionsTable {
  property tableId : String = "recent-transactions"
  property headerRow : Array(String) = ["Date", "Id", "Amount", "Token", "To", "From", "Category", "Status"]
  property rows : Array(RecentTransaction) = []

  fun trunc (value : String, length : Number) : String {
    `#{value}.substring(0,#{length})`
  }

  fun renderAddress (address : String, readable : String) : String {
    if (String.size(readable) > 0) {
      readable
    } else {
      trunc(address, 7)
    }
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

  fun renderCategory (category : String, direction : String) : Html {
    <div>
      <span class={"pr-2 " + directionStyle}/>

      <span class={"badge " + colour}>
        <{ category }>
      </span>
    </div>
  } where {
    colour =
      if (category == "Payment") {
        "bg-info-bright"
      } else if (category == "Mining reward") {
        "bg-secondary-bright"
      } else {
        "bg-warning-bright"
      }

    directionStyle =
      if (direction == "Incoming") {
        "text-success ti-arrow-down"
      } else {
        "text-danger ti-arrow-up"
      }
  }

  fun renderBodyRow (row : RecentTransaction) : Html {
    <tr>
      <td>
        <{ row.datetime }>
      </td>

      <td>
        <{ trunc(row.transactionId, 8) }>
      </td>

      <td>
        <{ row.amount }>
      </td>

      <td>
        <{ row.token }>
      </td>

      <td>
        <{ renderAddress(row.to, row.toReadable) }>
      </td>

      <td>
        <{ renderAddress(row.from, row.fromReadable) }>
      </td>

      <td>
        <{ renderCategory(row.category, row.direction) }>
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
    <p>
      "No transactions have been sent yet!"
    </p>
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
