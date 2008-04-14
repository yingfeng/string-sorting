<!--
  Copyright 2008 by Tommi Rantala <tommi.rantala@cs.helsinki.fi>

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to
  deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
  IN THE SOFTWARE.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:math="http://exslt.org/math">
	<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"/>
	<xsl:strip-space elements="*"/>
	<xsl:template match="/algs">
		<html>
			<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			<script src="sortable.js" type="text/javascript"/>
			<style type="text/css">
			<![CDATA[
			table.sortable {
				border-spacing: 0;
				border: 1px solid #000;
				border-collapse: collapse;
			}
			table.sortable th, table.sortable td {
				text-align: left;
				padding: 2px 4px 2px 4px;
				width: 100px;
				border-style: solid;
				border-color: #444;
			}
			table.sortable th {
				border-width: 0px 1px 1px 1px;
				background-color: #ccc;
			}
			table.sortable td {
				border-width: 0px 1px 0px 1px;
			}
			table.sortable tr.odd td {
				background-color: #ddd;
			}
			table.sortable tr.even td {
				background-color: #fff;
			}
			table.sortable tr.sortbottom td {
				border-top: 1px solid #444;
				background-color: #ccc;
				font-weight: bold;
			}
			a.popup {
				text-decoration: none;
				color: inherit;
			}
			a.popup:hover {
				color: blue;
			}
			div.popup {
				position: absolute;
				width: 90%;
				height: 90%;
				top: 5%;
				left: 5%;
				text-align: center;
			}
			div.popup iframe {
				width: 100%;
				height: 100%;
				background: white;
				border: 2px solid black;
			}
			]]>
			</style>
			<script type="text/javascript">
			<![CDATA[
			function createPopUp(destination) {
				var dsts   = destination.split(" ");
				var div    = document.createElement('div');
				var iframe = document.createElement('iframe');
				var br     = document.createElement('br');
				var close  = document.createElement('button');
				div.className = "popup";
				iframe.src = dsts[0];
				close.onclick = function () {
					this.parentNode.parentNode.removeChild(this.parentNode);
				}
				close.innerHTML = "Close";
				div.appendChild(close);
				if (dsts.length > 1) {
					for (var i=0; i < dsts.length; ++i) {
						var bt = document.createElement('button');
						bt.innerHTML = "Report "+i;
						bt.my_dest = dsts[i];
						bt.onclick = function() {
							var siblings = this.parentNode.childNodes;
							var i=0;
							for (; i < siblings.length; ++i) {
								if (siblings[i].tagName.toLowerCase() == 'iframe') {
									break;
								}
							}
							siblings[i].src = this.my_dest;
						}
						div.appendChild(bt);
					}
				}
				div.appendChild(br);
				div.appendChild(iframe);
				document.body.appendChild(div);
			}
			]]>
			</script>
			<!-- source: http://www.vonloesch.de/node/23 -->
			<script type="text/javascript">
			<![CDATA[
			function filter2 (phrase, _id){
				var words = phrase.toLowerCase().split(" ");
				var table = document.getElementById(_id);
				var ele;
				for (var r = 1; r < table.rows.length; r++) {
					ele = table.rows[r].innerHTML.replace(/<[^>]+>/g,"");
					var displayStyle = 'none';
					for (var i = 0; i < words.length; i++) {
						if (ele.toLowerCase().indexOf(words[i])>=0) {
							displayStyle = '';
						} else {
							displayStyle = 'none';
							break;
						}
					}
					table.rows[r].style.display = displayStyle;
				}
			}
			]]>
			</script>
			<script type="text/javascript">
			<![CDATA[
			function hidetable (_id) {
				var table = document.getElementById(_id);
				if (table.style.display.indexOf('none') >= 0) {
					table.style.display = '';
				} else {
					table.style.display = 'none';
				}
			}
			// Close popups with ESC
			function keyListener(e) {
				if (e.keyCode == 27) {
					// Removing nodes also shrinks the list.
					var popupList = document.getElementsByTagName("div");
					rm = popupList.length;
					for (var i=0; i < rm; ++i) {
						var popup = popupList[i];
						if (popup.className == "popup") {
							popup.parentNode.removeChild(popup);
							--rm; --i;
						}
					}
				}
			}
			]]>
			</script>
			</head>
			<body onload="document.onkeydown=keyListener">
				<!-- allows filtering algorithm names -->
				<form onreset="filter2('', 'genome3');filter2('', 'nodup3');filter2('', 'url3');">
					<xsl:text>Filter: </xsl:text>
					<input name="filter"
						onkeyup="filter2(this.value, 'genome3');filter2(this.value, 'nodup3');filter2(this.value, 'url3');"
						type="text"/>
					<input type="reset"/>
				</form>
				<form>
					<xsl:text>Show/hide tables: </xsl:text>
					<button type="button" onclick="hidetable('genome3')">genome3</button>
					<button type="button" onclick="hidetable('nodup3')">nodup3</button>
					<button type="button" onclick="hidetable('url3')">url3</button>
				</form>
				<center>
					<table class="sortable" id="genome3" summary="Comparison of algorithm performance with genome dataset.">
						<caption>genome3</caption>
						<xsl:call-template name="output-table-header"/>
						<xsl:call-template name="read-info">
							<xsl:with-param name="input">genome3</xsl:with-param>
						</xsl:call-template>
					</table>
					<table class="sortable" id="nodup3" summary="Comparison of algorithm performance with no-duplicates dataset.">
						<caption>nodup3</caption>
						<xsl:call-template name="output-table-header"/>
						<xsl:call-template name="read-info">
							<xsl:with-param name="input">nodup3</xsl:with-param>
						</xsl:call-template>
					</table>
					<table class="sortable" id="url3" summary="Comparison of algorithm performance with URL dataset.">
						<caption>url3</caption>
						<xsl:call-template name="output-table-header"/>
						<xsl:call-template name="read-info">
							<xsl:with-param name="input">url3</xsl:with-param>
						</xsl:call-template>
					</table>
				</center>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="output-table-header">
		<tr>
			<th>ID</th>
			<th>Name</th>
			<th>Time (ms)</th>
			<th>Clock cycles x10^6</th>
			<th>Instructions x10^6</th>
			<th>CPI</th>
			<th>DTLB misses x10^6</th>
			<th>L1 cache line misses x10^6</th>
			<th>L2 cache line misses x10^6</th>
			<th>Load blocks x10^6</th>
			<th>Store order blocks x10^6</th>
			<th>Heap peak (megabytes)</th>
			<th>{m,c,re}alloc calls</th>
		</tr>
	</xsl:template>
	<xsl:template name="read-info">
		<xsl:param name="input"/>
		<xsl:for-each select="/algs/alg">
			<tr>
				<td><xsl:value-of select="@algnum"/></td>
				<td><xsl:value-of select="@algname"/></td>
				<xsl:call-template name="get-timings">
					<xsl:with-param name="input"><xsl:value-of select="$input"/></xsl:with-param>
					<xsl:with-param name="algnum"><xsl:value-of select="@algnum"/></xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="get-oprofile-data">
					<xsl:with-param name="input"><xsl:value-of select="$input"/></xsl:with-param>
					<xsl:with-param name="algnum"><xsl:value-of select="@algnum"/></xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="get-memusage-data">
					<xsl:with-param name="input"><xsl:value-of select="$input"/></xsl:with-param>
					<xsl:with-param name="algnum"><xsl:value-of select="@algnum"/></xsl:with-param>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- timings data: we have 7 timings for each input & algorithm pair. Ignore
	smallest and largest, and pick the mean value of the remaining 5 times. Also
	show all the values in tooltip style using the abbr tag. -->
	<xsl:template name="get-timings">
		<xsl:param name="input"/>
		<xsl:param name="algnum"/>
		<td>
			<xsl:variable name="events" select="(
				document(concat('data/timings_', $input, '_', $algnum, '_1.xml')) |
				document(concat('data/timings_', $input, '_', $algnum, '_2.xml')) |
				document(concat('data/timings_', $input, '_', $algnum, '_3.xml')) |
				document(concat('data/timings_', $input, '_', $algnum, '_4.xml')) |
				document(concat('data/timings_', $input, '_', $algnum, '_5.xml')) |
				document(concat('data/timings_', $input, '_', $algnum, '_6.xml')) |
				document(concat('data/timings_', $input, '_', $algnum, '_7.xml'))
				)/event/time"/>
			<abbr title="{$events[1]/@seconds} {$events[2]/@seconds} {$events[3]/@seconds} {$events[4]/@seconds} {$events[5]/@seconds} {$events[6]/@seconds} {$events[7]/@seconds}">
			<xsl:value-of select="format-number(
				(sum($events/@seconds) - math:min($events/@seconds) - math:max($events/@seconds)) div 5,
				'#.##')"/></abbr>
		 </td>
	</xsl:template>
	<!-- oprofile data -->
	<xsl:template name="get-oprofile-data">
		<xsl:param name="input"/>
		<xsl:param name="algnum"/>
		<xsl:for-each select="document(concat('data/oprofile_', $input, '_', $algnum, '.xml'))">
			<td><a class="popup" onclick="createPopUp('data/opannotate_{$input}_{$algnum}_CPU_CLK_UNHALTED.html')">
					<xsl:value-of select="format-number(simple/event[@name='CPU_CLK_UNHALTED']/@value div 1e6,   '#')"/></a></td>
			<td><a class="popup" onclick="createPopUp('data/opannotate_{$input}_{$algnum}_INST_RETIRED.html')">
					<xsl:value-of select="format-number(simple/event[@name='INST_RETIRED.ANY_P']/@value div 1e6, '#')"/></a></td>
			<td><xsl:value-of
					select="format-number(simple/event[@name='CPU_CLK_UNHALTED']/@value div
					simple/event[@name='INST_RETIRED.ANY_P']/@value, '#.##')"/></td>
			<td><a class="popup" onclick="createPopUp('data/opannotate_{$input}_{$algnum}_DTLB_MISSES.html')">
					<xsl:value-of select="format-number(simple/event[@name='DTLB_MISSES']/@value div 1e6, '#')"/></a></td>
			<td><a class="popup" onclick="createPopUp('data/opannotate_{$input}_{$algnum}_MEM_LOAD_RETIRED_0x02.html')">
					<xsl:value-of select="format-number(simple/event[@name='MEM_LOAD_RETIRED' and @mask='2']/@value div 1e6, '#')"/></a></td>
			<td><a class="popup" onclick="createPopUp('data/opannotate_{$input}_{$algnum}_MEM_LOAD_RETIRED_0x08.html')">
					<xsl:value-of select="format-number(simple/event[@name='MEM_LOAD_RETIRED' and @mask='8']/@value div 1e6, '#')"/></a></td>
			<td><a class="popup" onclick="createPopUp('data/opannotate_{$input}_{$algnum}_LOAD_BLOCK_0x02.html data/opannotate_{$input}_{$algnum}_LOAD_BLOCK_0x04.html data/opannotate_{$input}_{$algnum}_LOAD_BLOCK_0x08.html data/opannotate_{$input}_{$algnum}_LOAD_BLOCK_0x10.html data/opannotate_{$input}_{$algnum}_LOAD_BLOCK_0x20.html')">
					<xsl:value-of select="format-number(
					(simple/event[@name='LOAD_BLOCK' and @mask='2']/@value +
					 simple/event[@name='LOAD_BLOCK' and @mask='4']/@value +
					  simple/event[@name='LOAD_BLOCK' and @mask='8']/@value +
					  simple/event[@name='LOAD_BLOCK' and @mask='16']/@value +
					  simple/event[@name='LOAD_BLOCK' and @mask='32']/@value) div 1e6,
						'#')"/></a></td>
			<td><a class="popup" onclick="createPopUp('data/opannotate_{$input}_{$algnum}_STORE_BLOCK_0x02.html')">
					<xsl:value-of select="format-number(simple/event[@name='STORE_BLOCK']/@value div 1e6, '#')"/></a></td>
		</xsl:for-each>
	</xsl:template>
	<!-- memusage data -->
	<xsl:template name="get-memusage-data">
		<xsl:param name="input"/>
		<xsl:param name="algnum"/>
		<xsl:for-each select="document(concat('data/memusage_', $input, '_', $algnum, '.xml'))">
			<td><a class="popup" onclick="createPopUp('data/memusage_{$input}_{$algnum}.html')">
					<xsl:value-of select="format-number(memusage/event/@heap-peak div 1048576, '#')"/></a></td>
			<td><xsl:value-of select="format-number(memusage/event/@calls-malloc + memusage/event/@calls-realloc + memusage/event/@calls-calloc, '#')"/></td>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
<!-- vim:ts=2:sw=2:
  -->
