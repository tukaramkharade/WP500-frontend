<!DOCTYPE html>

<head>
  <link href="https://fonts.googleapis.com/css?family=Lato:400,300,700" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="nav-bar.css" />
  <script src="jquery-3.6.0.min.js"></script>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />

  <title>WP500 Web Configuration</title>
  <link rel="icon" type="image/png" sizes="32x32" href="favicon.png" />
</head>

<body>
  <!-- <section class="header">
        <header>
          
          
        </header>
      </section> -->
  <section class="app">
    <aside class="sidebar">
      <header>
        <img src="images/tasm2m.png" width="70%" />
      </header>
      <nav class="sidebar-nav">
        <ul id="tabs">


          <li class="nav-item">
            <a class="dropdown-btn">
              <div class="sidebar-title">
                <img src="icons/system_white.png" />
                <div class="sidebar-title">System</div>
              </div>
            </a>
            <div class="dropdown-container">
              <ul id="tabs1">

                <li class="nav-item">
                  <a href="overview.jsp">Overview</a>
                </li>
                <%-- <li class="nav-item">
                  <a href="${pageContext.request.contextPath}/data">User List</a>
                </li> --%>
                
                <li class="nav-item">
                  <a href="user.jsp">User List</a>
                </li>
                
                <!-- <li class="nav-item">
                  <a href="#">Firmware</a>
                </li>
                <li class="nav-item">
                  <a href="#">License</a>
                </li>
                <li class="nav-item">
                  <a href="#">Backup</a>
                </li> -->
                <li class="nav-item">
                  <a href="reboot.jsp">Reboot</a>
                </li>
               <!--  <li class="nav-item">
                  <a href="#">Certificates</a>
                </li> -->
              </ul>
            </div>

          </li>

          <li class="nav-item">
            <a class="dropdown-btn">
              <div class="sidebar-title">
                <img src="icons/network_white.png" />
                <div class="sidebar-title">Network</div>
              </div>
            </a>
            <div class="dropdown-container">
              <ul>
                <li class="nav-item">
                  <a href="lan.jsp">LAN</a>
                </li>
                <li class="nav-item">
                  <a href="firewall.jsp">Firewall</a>
                </li>
                <li class="nav-item">
                  <a href="ntp.jsp">NTP</a>
                </li>
              </ul>
            </div>
          </li>
          <li class="nav-item">
            <a class="dropdown-btn">
              <div class="sidebar-title">
                <img src="icons/settings_white.png" />
                <div>Services</div>
              </div>
            </a>
            <div class="dropdown-container">
              <ul>

                <li class="nav-item">
                  <a href="mqtt.jsp">MQTT Server</a>
                </li>
                <li class="nav-item">
                  <a href="jsonbuilder.jsp">JSON Builder</a>
                </li>
                
                <li class="nav-item">
                <a href="dispensertrigger.jsp">Dispenser Trigger</a>
              </li>

                <!-- <li class="nav-item">
                  <a class="dropdown-subbtn">Straton
                    <i class="fa fa-caret-down"></i>
                    
                  </a>
                  <button class="dropdown-subbtn">Straton
                    <i class="fa fa-caret-down"></i>
                  </button>
                  <div class="dropdown-subcontainer">
                    <a onclick="openExtLink()">Straton Variable</a>
                    <a href="stratonlivedata.jsp">Straton Live Data</a>
                  </div>
                </li> -->
                
                <li class="nav-item">
                  <a href="stratonlivedata.jsp">Straton Live Data</a>
                </li>
                
                
                <li class="nav-item">
                  <a href="alarmconfig.jsp">Alarm Config</a>
                </li>
                <li class="nav-item">
                  <a href="commandconfig.jsp">Command Config</a>
                </li>
                <li class="nav-item">
                  <a href="storeforward.jsp">Store and Forward</a>
                </li>
              </ul>
            </div>
          </li>

          <li class="nav-item">
            <a class="dropdown-btn">
              <div class="sidebar-title">
                <img src="icons/status_white.png" />
                <div>Status</div>
              </div>
            </a>
            <div class="dropdown-container">
              <ul>
                <li class="nav-item">
                  <a href="logs.jsp">Logs</a>
                </li>
                <!-- <li class="nav-item">
                <a href="loadconfig.jsp">Load Config</a>
              </li> -->
              </ul>
            </div>
          </li>

        </ul>
      </nav>
    </aside>
  </section>
  <!-- <section class="footer">
        <footer>
          <span>COPYRIGHT � TAS INDIA PVT LTD, 2023</span>
        </footer>
      </section> -->

  <script>

    function openExtLink() {

      let url = window.location.protocol + "//" + window.location.host + "/webmon/index.html";

      window.open(url, '_blank').focus();
    }

    $(document).ready(function () {
      $("ul li > a").on("click", function () {
        $("ul").find(".active").removeClass("active");
        $(this).addClass("active");
      });

      $("ul li ul li> a").on("click", function () {
        $("ul").find(".active").addClass("active");
        $("ul li ul").find(".active").removeClass("active");
        $(this).addClass("active");
        $(this).parents("li").last().addClass("active");
      });
    });

    var dropdown = document.getElementsByClassName("dropdown-btn");
    var i;
    for (var j = 0; j < dropdown.length; j++) {
      dropdown[j].addEventListener("click", function () {
        for (i = 0; i < dropdown.length; i++) {
          var dropdownContent = dropdown[i].nextElementSibling;
          dropdownContent.style.display = "none";
        }

        var dropdownContent = this.nextElementSibling;
        if (dropdownContent.style.display === "block") {
          dropdownContent.style.display = "none";
        } else {
          dropdownContent.style.display = "block";
        }
      });
    }

    var subdropdown = document.getElementsByClassName("dropdown-subbtn");
    for (var k = 0; k < subdropdown.length; k++) {
      subdropdown[k].addEventListener("click", function () {
        for ( var l = 0; l < subdropdown.length; l++) {
          var subdropdownContent = dropdown[l].nextElementSibling;
          subdropdownContent.style.display = "none";
        }

        var subdropdownContent = this.nextElementSibling;
        if (subdropdownContent.style.display === "block") {
          subdropdownContent.style.display = "none";
        } else {
          subdropdownContent.style.display = "block";
        }
      });
    }
  </script>
</body>