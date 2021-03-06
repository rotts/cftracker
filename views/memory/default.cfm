<script type="text/javascript">
	$(function() {
		var aspects = ['Day', 'Week', 'Month', 'Year'];
		$('.rrd').each(function(num, el) {
			var id = el.id;
			var el = $(el);
			var fullId = '';
			var ts = new Date().getTime();
			for (var i = 0; i < aspects.length; i++) {
				fullId = id + '-' + aspects[i].toLowerCase();
				$('ul', el).append('<li><a href="#' + fullId + '">' + aspects[i] + '</a></li>');
				$(el).append('<cfoutput><div id="' + fullId + '" style="text-align:center;"><img src="#this.assetBegin#tools/monitor/images/' + fullId + '.png#this.assetEnd#?ts=' + ts + '" /></div></cfoutput>');
			}
			$(el).tabs()
		});
	});
	$(function() {
		$('.button[alt]').each(function(num, el) {
			el = $(el);
			el.button({
				icons: {
					primary: 'ui-icon-' + el.attr('alt')
				}
			})
			.attr('alt', null);
		});
	});
</script>
<script type="text/javascript" src="<cfoutput>#this.assetBegin#assets/js/swfobject.js#this.assetEnd#</cfoutput>"></script> 
<div class="span-24 last">
<h3>JVM Memory</h3>
<form action="<cfoutput>#BuildUrl(action = 'stats.gc', queryString = 'return=memory.default')#</cfoutput>" method="post">
	<button class="button" alt="trash">Run Garbage Collection</button>
</form>
</div>

<cfscript>
	data = {};
	data['Heap'] = '';
	data['NonHeap'] = '';
	for (key in data) {
		pools = StructKeyArray(rc.data.memory[key].pools);
		ArraySort(pools, 'textnocase');
		pLen = ArrayLen(pools);
		temp = [
			key,
			NumberFormat(rc.data.memory[key].usage.max / 1024^2, '.00'),
			NumberFormat(rc.data.memory[key].usage.committed / 1024^2, '.00'),
			NumberFormat(rc.data.memory[key].usage.free / 1024^2, '.00'),
			NumberFormat(rc.data.memory[key].usage.used / 1024^2, '.00')
		];
		data[key] = ArrayToList(temp, ';');
		for (i = 1; i Lte pLen; i++) {
			temp = [
				pools[i],
				NumberFormat(rc.data.memory[key].pools[pools[i]].usage.max / 1024^2, '.00'),
				NumberFormat(rc.data.memory[key].pools[pools[i]].usage.committed / 1024^2, '.00'),
				NumberFormat(rc.data.memory[key].pools[pools[i]].usage.free / 1024^2, '.00'),
				NumberFormat(rc.data.memory[key].pools[pools[i]].usage.used / 1024^2, '.00')
			];
			data[key]  &= '\n' & ArrayToList(temp, ';');
		}
	}
</cfscript>
<script type="text/javascript">
	var fCharts = {};
	var amChartInited = function(chart_id) {
		fCharts[chart_id] = $('#' + chart_id).get(0);
		<cfoutput><cfloop collection="#data#" item="key">
			if (chart_id == '#key#') {
				fCharts[chart_id].setData('<cfoutput>#data[key]#</cfoutput>');
			}
		</cfloop></cfoutput>
	};
</script>

<div class="span-12">
	<h4>Heap</h4>
	<script type="text/javascript"><cfoutput>
		$(function() {
			var flashvars = {
				path: '#this.assetBegin#assets/flash/amcolumn#this.assetEnd#',
				settings_file: '#this.assetBegin#assets/flash/amcolumn/' + encodeURIComponent('heap.xml') + '#this.assetEnd#',
				data_file: '#this.assetBegin#assets/flash/amcolumn/' + encodeURIComponent('empty.csv') + '#this.assetEnd#',
				chart_id: 'Heap'
			};
			var flashparams = {
				wmode: 'opaque'
			};
			swfobject.embedSWF('#this.assetBegin#assets/flash/amcolumn/amcolumn.swf#this.assetEnd#', 'Heap', '450', '350', '8', 'assets/flash/expressInstall.swl', flashvars, flashparams);
		});
	</cfoutput></script>
	<div id="Heap" class="graph">&nbsp;</div>
	<cfif FileExists(application.base & 'tools/monitor/images/memory-heap-day.png')>
		<div class="rrd" id="memory-heap"><ul></ul></div>
	<cfelse>
		<cfoutput><img src="#this.assetBegin#assets/images/norrd.png#this.assetEnd#" /></cfoutput>
	</cfif>
	<table class="styled narrow rightVals">
		<thead>
			<tr>
				<th scope="col">Name</th>
				<th scope="col">Max</th>
				<th scope="col">Allocated</th>
				<th scope="col">Used</th>
				<th scope="col">Free</th>
			</tr>
		</thead>
		<tbody><cfoutput>
			<tr>
				<th scope="row">Heap</th>
				<td>#SiPrefix(rc.data.memory.heap.usage.max, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.heap.usage.committed, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.heap.usage.used, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.heap.usage.free, 1024)#B</td>
			</tr>
			<tr>
				<th scope="row" style="text-align:right">(Peak)</th>
				<td>#SiPrefix(rc.data.memory.heap.peakusage.max, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.heap.peakusage.committed, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.heap.peakusage.used, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.heap.peakusage.free, 1024)#B</td>
			</tr>
			<cfloop collection="#rc.data.memory.heap.pools#" item="pool">
				<tr>
					<th scope="row">#HtmlEditFormat(pool)#</th>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].usage.max, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].usage.committed, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].usage.used, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].usage.free, 1024)#B</td>
				</tr>
				<tr>
					<th scope="row" style="text-align:right">(Peak)</th>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].peakusage.max, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].peakusage.committed, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].peakusage.used, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].peakusage.free, 1024)#B</td>
				</tr>
			</cfloop>
		</cfoutput></tbody>
	</table>
</div>
<div class="span-12 last">
	<h4>Non-heap</h4>
	<script type="text/javascript"><cfoutput>
		$(function() {
			var flashvars = {
				path: '#this.assetBegin#assets/flash/amcolumn#this.assetEnd#',
				settings_file: '#this.assetBegin#assets/flash/amcolumn/' + encodeURIComponent('heap.xml') + '#this.assetEnd#',
				data_file: '#this.assetBegin#assets/flash/amcolumn/' + encodeURIComponent('empty.csv') + '#this.assetEnd#',
				chart_id: 'NonHeap'
			};
			var flashparams = {
				wmode: 'opaque'
			};
			swfobject.embedSWF('#this.assetBegin#assets/flash/amcolumn/amcolumn.swf#this.assetEnd#', 'NonHeap', '450', '350', '8', '#this.assetBegin#assets/flash/expressInstall.swf#this.assetEnd#', flashvars, flashparams);
		});
	</cfoutput></script>
	<div id="NonHeap"></div>
	<cfif FileExists(application.base & 'tools/monitor/images/memory-nonheap-day.png')>
		<div class="rrd" id="memory-nonheap"><ul></ul></div>
	<cfelse>
		<cfoutput><img src="#this.assetBegin#assets/images/norrd.png#this.assetEnd#" /></cfoutput>
	</cfif>
	<table class="styled narrow rightVals">
		<thead>
			<tr>
				<th scope="col">Name</th>
				<th scope="col">Max</th>
				<th scope="col">Allocated</th>
				<th scope="col">Used</th>
				<th scope="col">Free</th>
			</tr>
		</thead>
		<tbody><cfoutput>
			<tr>
				<th scope="row">Non-heap</th>
				<td>#SiPrefix(rc.data.memory.nonheap.usage.max, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.nonheap.usage.committed, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.nonheap.usage.used, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.nonheap.usage.free, 1024)#B</td>
			</tr>
			<tr>
				<th scope="row" style="text-align:right">(Peak)</th>
				<td>#SiPrefix(rc.data.memory.nonheap.peakusage.max, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.nonheap.peakusage.committed, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.nonheap.peakusage.used, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.nonheap.peakusage.free, 1024)#B</td>
			</tr>
			<cfloop collection="#rc.data.memory.nonheap.pools#" item="pool">
				<tr>
					<th scope="row">#HtmlEditFormat(pool)#</th>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].usage.max, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].usage.committed, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].usage.used, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].usage.free, 1024)#B</td>
				</tr>
				<tr>
					<th scope="row" style="text-align:right">(Peak)</th>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].peakusage.max, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].peakusage.committed, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].peakusage.used, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].peakusage.free, 1024)#B</td>
				</tr>
			</cfloop>
		</cfoutput></tbody>
	</table>
</div>

<div class="span-24 last">
	<h3>Garbage Collection</h3>
</div>
<cfset num = 1 />
<cfoutput>
<cfloop array="#rc.data.garbage#" index="gc">
	<div class="span-12 <cfif num Mod 2 Eq 0>last</cfif>">
		<h4>#HtmlEditFormat(gc.name)#</h4>
		<cfif FileExists(application.base & 'tools/monitor/images/garbage' & num & '-day.png')>
			<div class="rrd" id="garbage#num#"><ul></ul></div>
		<cfelse>
			<cfoutput><img src="#this.assetBegin#assets/images/norrd.png#this.assetEnd#" /></cfoutput>
		</cfif>
		<table class="styled narrow rightVals">
			<caption>Information</caption>
			<thead>
				<tr>
					<th scope="col">Aspect</th>
					<th scope="col">Value</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th scope="row">Collections</th>
					<td>#NumberFormat(gc.collections)#</td>
				</tr>
				<tr>
					<th scope="row">Total duration</th>
					<td>#SiPrefix(gc.totalDuration / 1000)#s</td>
				</tr>
				<tr>
					<th scope="row">Average duration</th>
					<td><cfif gc.collections Eq 0>0<cfelse>#SiPrefix(gc.totalDuration / gc.collections / 1000)#s</cfif></td>
				</tr>
				<tr>
					<th scope="row">Pools collecting</th>
					<td>#ArrayToList(gc.pools, ', ')#</td>
				</tr>
			</tbody>
		</table>
		<h5>Last collection</h5>
		<table class="styled narrow rightVals">
			<caption>Last collection</caption>
			<thead>
				<tr>
					<th scope="col">Aspect</th>
					<th scope="col">Value</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th scope="row">Start time</th>
					<td>#DateFormat(gc.starttime, application.settings.display.dateformat)# #TimeFormat(gc.starttime, application.settings.display.timeformat)#</td>
				</tr>
				<tr>
					<th scope="row">End time</th>
					<td>#DateFormat(gc.endtime, application.settings.display.dateformat)# #TimeFormat(gc.endtime, application.settings.display.timeformat)#</td>
				</tr>
				<tr>
					<th scope="row">Duration</th>
					<td>#SiPrefix(gc.duration / 1000)#s</td>
				</tr>
			</tbody>
		</table>
		<table class="styled narrow rightVals">
			<caption>Pool usage</caption>
			<thead>
				<tr>
					<th scope="col">Pool</th>
					<th scope="col">When</th>
					<th scope="col">Allocated</th>
					<th scope="col">Used</th>
					<th scope="col">Free</th>
					<th scope="col">Max</th>
				</tr>
			</thead>
			<tbody>
				<cfloop collection="#gc.usage#" item="pName">
					<tr>
						<th scope="row" rowspan="2">#HtmlEditFormat(pName)#</th>
						<th scope="row">Before</th>
						<td>#siPrefix(gc.usage[pName].before.committed, 1024)#B</td>
						<td>#siPrefix(gc.usage[pName].before.used, 1024)#B</td>
						<td>#siPrefix(gc.usage[pName].before.free, 1024)#B</td>
						<td>#siPrefix(gc.usage[pName].before.max, 1024)#B</td>
					</tr>
					<tr>
						<th scope="row">After</th>
						<td>#siPrefix(gc.usage[pName].after.committed, 1024)#B</td>
						<td>#siPrefix(gc.usage[pName].after.used, 1024)#B</td>
						<td>#siPrefix(gc.usage[pName].after.free, 1024)#B</td>
						<td>#siPrefix(gc.usage[pName].after.max, 1024)#B</td>
					</tr>	
				</cfloop>
			</tbody>
		</table>
	</div>
	<cfset num++ />
</cfloop>
</cfoutput>

<div class="span-24 last"><h3>Operating System</h3></div>
<div class="span-12">
	<cfif FileExists(application.base & 'tools/monitor/images/os-phy-day.png')>
		<div class="rrd" id="os-phy"><ul></ul></div>
	<cfelse>
		<cfoutput><img src="#this.assetBegin#assets/images/norrd.png#this.assetEnd#" /></cfoutput>
	</cfif>
	<table class="styled narrow rightVals">
		<caption>Physical</caption>
		<thead>
			<tr>
				<th scope="col">Max</th>
				<th scope="col">Used</th>
				<th scope="col">Free</th>
			</tr>
		</thead>
		<tbody><cfoutput>
			<tr>
				<td>#SiPrefix(rc.data.memory.os.physicalTotal, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.os.physicalUsed, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.os.physicalFree, 1024)#B</td>
			</tr>
		</cfoutput></tbody>
	</table>
</div>
<div class="span-12 last">
	<cfif FileExists(application.base & 'tools/monitor/images/os-swap-day.png')>
		<div class="rrd" id="os-swap"><ul></ul></div>
	<cfelse>
		<cfoutput><img src="#this.assetBegin#assets/images/norrd.png#this.assetEnd#" /></cfoutput>
	</cfif>
	<table class="styled narrow rightVals">
		<caption>Swap</caption>
		<thead>
			<tr>
				<th scope="col">Max</th>
				<th scope="col">Used</th>
				<th scope="col">Free</th>
			</tr>
		</thead>
		<tbody><cfoutput>
			<tr>
				<td>#SiPrefix(rc.data.memory.os.swapTotal, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.os.swapUsed, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.os.swapFree, 1024)#B</td>
			</tr>
		</cfoutput></tbody>
	</table>
</div>