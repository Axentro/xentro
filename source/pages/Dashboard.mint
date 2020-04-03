component Dashboard {

 fun componentDidMount : Promise(Never, Void) {
        `
    (() => {
     window.requestAnimationFrame(function () {

       
		var preLoder = $("#preloader");
		preLoder.delay(700).fadeOut(500);

         $('#recent-orders').DataTable();
   
    });
    })()
    `
  }

  fun render : Html {
    <div>


<div id="preloader" class="preloader">
    <div class="preloader-icon"></div>
</div>






<div class="layout-wrapper">

  
    <div class="header d-print-none">

        <div class="header-left">
            <div class="navigation-toggler">
                <a href="#" data-action="navigation-toggler">
                    <i data-feather="menu"></i>
                </a>
            </div>
            <div class="header-logo">
                <a href="index.html">
                    <img class="logo" src="/assets/media/image/logo.png" alt="logo"/>
                    <img class="logo-light" src="/assets/media/image/logo-light.png" alt="light logo"/>
                </a>
            </div>
        </div>

        <div class="header-body">
            <div class="header-body-left">
             <ul class="navbar-nav">
            <li class="nav-item">
              <a class="nav-link" href="#">"Send"</a>
            </li>
             <li class="nav-item">
              <a class="nav-link" href="#">"Receive"</a>
            </li>
              <li class="nav-item">
              <a class="nav-link" href="#">"All transactions"</a>
            </li>
            </ul>    
            </div>
            <div class="header-body-right">    

           
            </div>
        </div>

    </div>
 

    <div class="content-wrapper">

       
      
      

        <div class="content-body">

            <div class="content">

                
    <div class="page-header">
   
    </div>

    <div class="row">
        <div class="col-md-12">

            <div class="row">
                <div class="col-md-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-3">
                                <div>
                                    <p class="text-muted">"Wallet Balances"</p>
                                    <h2 class="font-weight-bold">"58,000"  <span class="small">" SUSHI"</span></h2>
                                   
                                </div>
                          
                            </div>
                            <div class="small">
                               "VDBjMjI1ZmE0MmQzYTAwYWJlZGNjMTFkNzQ5YjMxZGFkNGVhYjU2N2YwNzFmYjFk"
                            </div>
                        </div>
                  
                 
                   <div class="table-responsive">
                    <table class="table table-striped mb-0">
                        <thead>
                        <tr>
                            <th>"Token"</th>
                            <th>"Amount"</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>
                                "KINGS"
                            </td>
                            <td>"0.001"</td>
                        </tr>
                        <tr>
                            <td>
                                "XCURRENCY"
                            </td>
                            <td>"897"</td>
                        </tr>
                        <tr>
                            <td>
                                "EAGLE"
                            </td>
                            <td>"1,200,000"</td>
                        </tr>
                        </tbody>
                    </table>
                   </div>
                 </div>
                </div>
                 <div class="col-md-9">
                    <div class="card">
        <div class="card-body">
            <div>
                <h6 class="card-title">"Pending Transactions"</h6>
            </div>
            <div class="row">
                <div class="col-md-12">
                  
                        <table id="recent-orders" class="table table-striped table-bordered">
                            <thead>
                            <tr>
                                <th>"Date"</th>
                                <th>"Id"</th>
                                <th>"Amount"</th>
                                <th>"Token"</th>
                                <th>"From"</th>
                                <th>"Category"</th>
                                <th>"Direction"</th>
                                <th>"Status"</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                             <td>
                                "2020-03-29 16:43:14 UTC"
                                </td>
                                <td>
                                    "60961f3c5f0f7a3"
                                </td>
                                <td>
                                  "0.00345"
                                </td>
                                <td>"SUSHI"</td>
                                <td>"KINGS.sc"</td>
                                <td>
                                  "Payment"  
                                </td>
                                <td>"Incoming"</td>
                                <td>"Completed"</td>
                            </tr>
                            </tbody>
                        </table>
                  
                </div>
            </div>
        </div>
    </div>
                </div>
            </div>

        </div>
    </div>

  

   

  


            </div>

          

         

        </div>

    </div>

</div>



    <div class="colors">
        <div class="bg-primary"></div>
        <div class="bg-primary-bright"></div>
        <div class="bg-secondary"></div>
        <div class="bg-secondary-bright"></div>
        <div class="bg-info"></div>
        <div class="bg-info-bright"></div>
        <div class="bg-success"></div>
        <div class="bg-success-bright"></div>
        <div class="bg-danger"></div>
        <div class="bg-danger-bright"></div>
        <div class="bg-warning"></div>
        <div class="bg-warning-bright"></div>
    </div>

  




</div>
  }

}