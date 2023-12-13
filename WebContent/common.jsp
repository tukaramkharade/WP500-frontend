<!DOCTYPE html>

<head>
 <link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">
<link rel="stylesheet" href="css_files/font-awesome.min.css">

  <link rel="stylesheet" href="nav-bar.css" />
  <script src="jquery-3.6.0.min.js"></script>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />

  <title>WPConnex Web Configuration</title>
  <link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
</head>

<style>

.sidebar-nav>ul>li>a:after {
	  content: ">";
	  font-family: ionicons;
	  font-size: 0.5em;
	  width: 10px;
	  color: #fff;
	  position: absolute;
	  right: 0.75em;
	  top: 45%;
	  display: none;
	}
</style>

<body>
  
  <section class="app">
    <aside class="sidebar">
      <header>
        <img src="images/WP_connex_logo_full.png" width="70%" />
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
                
                <li class="nav-item">
                  <a href="user.jsp">User List</a>
                </li>
               
                 <li class="nav-item">
                  <a href="firmwareUpdate.jsp">Firmware Update</a>
                </li>
                
                <li class="nav-item">
                  <a href="backup.jsp">Backup and Restore</a>
                </li> 
                
                <li class="nav-item">
                  <a href="reboot.jsp">Reboot and Factory Reset</a>
                </li>
              
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
                  <a href="trafficrules_new.jsp">Traffic Rules</a>
                </li>
                <li class="nav-item">
                  <a href="ntp.jsp">NTP</a>
                </li>
                <li class="nav-item">
                  <a href="wireguard.jsp">Wireguard</a>
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
				<li class="nav-item" style="color: white; font-size: 16px;"><b>
                MQTT</b>
              </li>
                <li class="nav-item">
                  <a href="mqtt.jsp">MQTT Server</a>
                </li>
                <li class="nav-item">
                  <a href="jsonbuilder.jsp">JSON Builder</a>
                </li>
                
                <li class="nav-item">
                <a href="dispensertrigger.jsp">Dispenser Trigger</a>
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
                
                 <li class="nav-item">
               
              </li>
              
                <li class="nav-item" style="color: white; font-size: 16px;"><b>
                OPC</b>
              </li>
                
                <li class="nav-item">
                <a href="opcuaClient.jsp">OPCUA Clients</a>
              </li>
              
              
              <li class="nav-item">
                <a href="browsequickclient.jsp">Quick Client</a>
              </li>
              
               <li class="nav-item">
                <a href="TagMapping.jsp">Tags</a>
              </li>
              
              <li class="nav-item">
               
              </li>
              
              <li class="nav-item" style="color: white; font-size: 16px;"><b>
                Certificate</b>
              </li>
              
              
               <li class="nav-item">
                <a href="certificate.jsp">Certificate</a>
              </li>
              
               <li class="nav-item">
               
              </li>
              
              <li class="nav-item" style="color: white; font-size: 16px;"><b>
                Settings</b>
              </li>
              
              <li class="nav-item">
                <a href="generalsettings.jsp">General Settings</a>
              </li>
              
               <li class="nav-item">
                <a href="syslogServer.jsp">Syslog Configuration</a>
              </li>
              
              <li class="nav-item">
                <a href="bannertext.jsp">Banner Text</a>
              </li>
              
              <li class="nav-item">
               
              </li>
              
              <li class="nav-item" style="color: white; font-size: 16px;"><b>
                Workbench</b>
              </li>
              
              <li class="nav-item">
                  <a href="wpconnexworkbench.jsp">Workbench</a>
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
                <li class="nav-item">
                  <a href="systemlog.jsp">System Logs</a>
                </li>
                 <!-- <li class="nav-item">
                <a href="event.jsp">Events</a>
              </li>  -->
              </ul>
            </div>
          </li>
          
          <li class="nav-item">
            <a class="dropdown-btn">
              <div class="sidebar-title">
                <img src="icons/cyberguard.png" />
                <div class="sidebar-title">CyberGuard</div>
              </div>
            </a>
            <div class="dropdown-container">
              <ul>
              <li class="nav-item">
                  <a href="dashboard.jsp">Dashboard</a>
                </li>
                <li class="nav-item">
                  <a href="activethreats.jsp">Active Threats</a>
                </li>
                <li class="nav-item">
                  <a href="threatlogs.jsp">Threat Logs</a>
                </li>
                <li class="nav-item">
                  <a href="smtp.jsp">SMTP Settings</a>
                </li>
                <li class="nav-item">
                  <a href="process.jsp">Process</a>
                </li>
              </ul>
            </div>
          </li>
          
          <li class="nav-item">
            <a class="dropdown-btn">
              <div class="sidebar-title">
                <img src="icons/user_profile.png" />
                <div class="sidebar-title">User Profile</div>
              </div>
            </a> 
            
            <div class="dropdown-container">
              <ul>
              <li class="nav-item">
                  <a href="twofactorAuth.jsp">2 Factor Auth</a>
                </li>
                <li class="nav-item">
                  <a href="changeoldpassword.jsp">Reset Password</a>
                </li>
                
              </ul>
            </div>
            
            </li>

        </ul>
      </nav>
    </aside>
  </section>
 
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