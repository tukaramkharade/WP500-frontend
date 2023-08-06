<!DOCTYPE html>
<html>
<head>
<title>WP500 Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
	function loadStratonLiveDataList() {
		$.ajax({
			url : 'stratonLiveDataServlet',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				// Clear existing table rows
				
				
				var stratonLiveTable = $('#data-table tbody');
				stratonLiveTable.empty();

				// Iterate through the user data and add rows to the table
				$.each(data, function(index, stratonLiveData) {
					
					
					var row = $('<tr>');
					row.append($('<td>').text(stratonLiveData.tag_name + ""));
					row.append($('<td>').text(stratonLiveData.value + ""));
					row.append($('<td>').text(stratonLiveData.extError + ""));
					row.append($('<td>').text(stratonLiveData.access + ""));	
					row.append($('<td>').text(stratonLiveData.error + ""));
					

					stratonLiveTable.append(row);

				});
			},
			error : function(xhr, status, error) {
				console.log('Error loading straton live data: ' + error);
			}
		});
	}

	$(document).ready(function() {
		loadStratonLiveDataList();

	});
</script>
</head>


<body>
	<div class="sidebar"><%@ include file="common.jsp"%></div>
	<div class="header"><%@ include file="header.jsp"%></div>
	<div class="content">
		<section style="margin-left: 1em">
			<h3>STRATON LIVE DATA</h3>
			<hr />

			<div class="container">
			
				<table id="data-table">
				<thead>
					<tr>
					<th>Tag Name</th>
					<th>Value</th>
						<th>ExtError</th>
						<th>Access</th>
						
						<th>Error</th>
						
					</tr>
					</thead>
					<tbody>
						<!-- Table rows will be dynamically generated here -->
					</tbody>
				</table>
			</div>
		</section>
	</div>
	<!-- <script>
      const data = [
        {
          extError: 0,
          access: 3,
          tag_name: "TTAFTCLR",
          error: 200,
          value: "0",
        },
        { extError: 0, access: 3, tag_name: "TTS2OUT", error: 200, value: "0" },
        {
          extError: 0,
          access: 3,
          tag_name: "AUXWTRTT",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "BUSBNKPT",
          error: 200,
          value: "0",
        },
        { extError: 0, access: 3, tag_name: "PTSUC", error: 200, value: "0" },
        { extError: 0, access: 3, tag_name: "PTS3IN3", error: 200, value: "0" },
        { extError: 0, access: 3, tag_name: "PTS3OUT", error: 200, value: "0" },
        {
          extError: 0,
          access: 3,
          tag_name: "ENGVIBRN_XMTR",
          error: 200,
          value: "0",
        },
        { extError: 0, access: 3, tag_name: "TTCPOIL", error: 200, value: "0" },
        { extError: 0, access: 3, tag_name: "RUNHR", error: 200, value: "0" },
        {
          extError: 0,
          access: 3,
          tag_name: "B_PRESS_1",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "PTHIGBAN",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "PTLOWBAN",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "A_B_STATUS",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "FMCNGDIS",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "B_FM_MASSTOTAL",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "A_FM_MASSTOTAL",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "B_GASRATE",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "B_DISPMETEREDTOTAL",
          error: 200,
          value: "0",
        },
        { extError: 0, access: 3, tag_name: "TTS2IN", error: 200, value: "0" },
        { extError: 0, access: 3, tag_name: "PTCPOIL", error: 200, value: "0" },
        {
          extError: 0,
          access: 3,
          tag_name: "A_CURRENTFILLPRICE",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "ENGOILPT",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "FZCNGDIS",
          error: 200,
          value: "0",
        },
        { extError: 0, access: 3, tag_name: "B_TRG", error: 200, value: "0" },
        { extError: 0, access: 3, tag_name: "COMSTS", error: 200, value: "0" },
        {
          extError: 0,
          access: 3,
          tag_name: "COMPGD01",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "COMPGD02",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "B_LASTFILLQTY",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "B_CURRENTFILLQTY",
          error: 200,
          value: "0",
        },
        { extError: 0, access: 3, tag_name: "A_TRG", error: 200, value: "0" },
        {
          extError: 0,
          access: 3,
          tag_name: "DIS_COMSTS",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "MOBBNKPT",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "ENGFUELPT",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "B_LASTFILLPRICE",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "CTRLAIRPT",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "ENGLUBOILTT",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "A_GASFLORATE",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "A_PRESS_1",
          error: 200,
          value: "0",
        },
        { extError: 0, access: 3, tag_name: "V43", error: 200, value: "0" },
        {
          extError: 0,
          access: 3,
          tag_name: "PTGASREC",
          error: 200,
          value: "0",
        },
        { extError: 0, access: 3, tag_name: "V44", error: 200, value: "0" },
        { extError: 0, access: 3, tag_name: "PTS1IN1", error: 200, value: "0" },
        { extError: 0, access: 3, tag_name: "RUNMIN", error: 200, value: "0" },
        {
          extError: 0,
          access: 3,
          tag_name: "A_PRESS_2",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "ENGEXHTTT",
          error: 200,
          value: "0",
        },
        { extError: 0, access: 3, tag_name: "TTS3OUT", error: 200, value: "0" },
        {
          extError: 0,
          access: 3,
          tag_name: "ENGJKTWTROUTTT",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "B_GASFLORATE",
          error: 200,
          value: "0",
        },
        { extError: 0, access: 3, tag_name: "TRUNHR", error: 200, value: "0" },
        {
          extError: 0,
          access: 3,
          tag_name: "A_DISPMETEREDTOTAL",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "ENGJKTWTRINTT",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "TTS1OUT2",
          error: 200,
          value: "0",
        },
        { extError: 0, access: 3, tag_name: "ENGSP", error: 200, value: "0" },
        { extError: 0, access: 3, tag_name: "TRUNMIN", error: 200, value: "0" },
        {
          extError: 0,
          access: 3,
          tag_name: "RTC_CLOCK",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "A_CURRENTFILLQTY",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "A_LASTFILLPRICE",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "PTS3OUT3",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "A_GASRATE",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "B_CURRENTFILLPRICE",
          error: 200,
          value: "0",
        },
        { extError: 0, access: 3, tag_name: "TTS3IN", error: 200, value: "0" },
        {
          extError: 0,
          access: 3,
          tag_name: "A_LASTFILLQTY",
          error: 200,
          value: "0",
        },
        { extError: 0, access: 3, tag_name: "PTS2IN2", error: 200, value: "0" },
        {
          extError: 0,
          access: 3,
          tag_name: "VIBRN_XMTR",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "PTMEDBAN",
          error: 200,
          value: "0",
        },
        {
          extError: 0,
          access: 3,
          tag_name: "FZCNGSUC",
          error: 200,
          value: "0",
        },
        { extError: 0, access: 3, tag_name: "TTS1IN", error: 200, value: "0" },
        {
          extError: 0,
          access: 3,
          tag_name: "FMCNGSUC",
          error: 200,
          value: "0",
        },
      ];

      const tableBody = document.getElementById("table-body");

      data.forEach((item) => {
        const row = document.createElement("tr");

        const extErrorCell = document.createElement("td");
        extErrorCell.textContent = item.extError;
        row.appendChild(extErrorCell);

        const accessCell = document.createElement("td");
        accessCell.textContent = item.access;
        row.appendChild(accessCell);

        const tagNameCell = document.createElement("td");
        tagNameCell.textContent = item.tag_name;
        row.appendChild(tagNameCell);

        const errorCell = document.createElement("td");
        errorCell.textContent = item.error;
        row.appendChild(errorCell);

        const valueCell = document.createElement("td");
        valueCell.textContent = item.value;
        row.appendChild(valueCell);

        tableBody.appendChild(row);
      });
    </script> -->
	<div class="footer"><%@ include file="footer.jsp"%></div>
</body>
</html>
