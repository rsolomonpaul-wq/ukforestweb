var infoselected = "0";
var pdetailsselected = "0";
var buffersselected = "0";
var url;
function setselectedinfo() {

    if (pdetailsselected == "0") {
        if (buffersselected == "0") {
            jQuery('#info').toggleClass('iconenable');
            if (infoselected == 0) {
                infoselected = "1";
                map.on('singleclick', featureInfo_2);
            } else {
                map.un('singleclick', featureInfo_2);
                infoselected = "0";
            }
        }
        else {

            alert("Buffer Area is already selected , first unselect after that click.")
        }
    }
    else {
        alert("Edit Property Details Control is already selected , first unselect after that click.")
    }
}
var rowWiseArray_1 = [];
var featureInfo_2 = function (evt) {

    if (infoselected == 1) {
        var _CustomObject = new ol.layer.Image();
        for (i = 0; i < lastselectedlayer.length; i++) {
            fetch_layername = lastselectedlayer[i];
            console.log(lastselectedlayer[i]);
            if (lastselectedlayer[i] == lastselectedlayer[i]) {
                var _CustomObject = new ol.layer.Image({
                    source: new ol.source.ImageWMS({
                        ratio: 1,
                        url: geoserver_ip,
                        serverType: 'geoserver',
                        crossOrigin: 'anonymous',
                        params: {
                            'FORMAT': format,
                            tiled: true,
                            STYLES: '',
                            LAYERS: 'nrdc:' + lastselectedlayer[i],
                            transition: 0,
                        }
                    })
                });
            }
        }
        var view = map.getView();
        var viewResolution = view.getResolution();
        var source;
        if (_CustomObject.get('visible')) {
            source = _CustomObject.getSource();
        } else {
        }
        try {
            console.log(lastselectedlayer[lastselectedlayer.length-1]);
            var counter = "";;
            console.log('counter=', counter);
            url = source.getGetFeatureInfoUrl(evt.coordinate, viewResolution, view.getProjection(), { 'INFO_FORMAT': 'text/html', 'FEATURE_COUNT': parseInt(counter) });
        } catch (e) {
        }
        if (url) {
            console.log(url);
            var _coordinate = evt.coordinate;
            overlay.setPosition(evt.coordinate);
            fetch(url)
                .then(response => response.text())
                .then(contents => showpopupinfo(contents, _coordinate, fetch_layername));
        }

    }
    else {
        var coord = ol.proj.toLonLat(evt.coordinate);
        var _coordinate = evt.coordinate;
    }
}
function capitalize_Words(str) {
    str = String(str);
    return str.replace(/(?:_| |\b)(\w)/g, function ($1) { return $1.toUpperCase().replace('_', ' '); });
}
function roundIfNumeric(value) {
    if (!isNaN(value) && !isNaN(parseFloat(value))) {
        return parseFloat(value).toFixed(2);
    }
    return value;
}
function showpopupinfo(result, _coordinate, fetch_layername) {

    var globalCollectionArray = [];
    var headerColumns = [];
    jQuery(result).find('tr').each(function (indexno) {
        if (indexno == 0) {
            jQuery(this).find('th').each(function () {
                headerColumns.push(jQuery(this).text());
            });
        } else {
            var rowWiseArray = [];
            jQuery(this).find('td').each(function (index) {
                var headingstring = headerColumns[index];
                if (!headingstring.includes('fid') && !headingstring.includes('id') && !headingstring.includes('dr') && !headingstring.includes('sl_no') && !headingstring.includes('blksectnrd') && !headingstring.includes('forest_blk') && !headingstring.includes('beat') && !headingstring.includes('comprtntn') && !headingstring.includes('layer') && !headingstring.includes('map_name') && !headingstring.includes('border_col') && !headingstring.includes('closed') && !headingstring.includes('border_wid') && !headingstring.includes('border_sty') && !headingstring.includes('fill_style') && !headingstring.includes('type') && !headingstring.includes('sub_cat') && !headingstring.includes('rural__') && !headingstring.includes('state_lgd') && !headingstring.includes('shape_leng') && !headingstring.includes('district_l') && !headingstring.includes('shape_area') && !headingstring.includes('region') && !headingstring.includes('shape_le_1') && !headingstring.includes('urban__') && !headingstring.includes('total__') && !headingstring.includes('district_1') && !headingstring.includes('district_l') && !headingstring.includes('popu_cls')) {
                    // if (true) {
                    //CREATING JSON OBJECT
                    var CustomObject = { column: headerColumns[index], value: jQuery(this).text() };
                    rowWiseArray.push(CustomObject)
                }
            });
            globalCollectionArray.push({ row: rowWiseArray });
        }
    });
    var makeCustomHTML = '<div class=\'info-table-heading\'><span>' + lastselectedlayername[Number(lastselectedlayername.length) - 1] + '</span></div>';
    makeCustomHTML += ' <div style=\'overflow-y: auto; max-height: 250px;\'>';
    for (var i in globalCollectionArray) {
        makeCustomHTML += '<div class=\'layer-info-popup\'><table >';
        for (var j in globalCollectionArray[i].row) {
            var capt = capitalize_Words(globalCollectionArray[i].row[j].column);
            var val = capitalize_Words(globalCollectionArray[i].row[j].value);
            var re = /^[-+]?[0-9]+\.[0-9]+jQuery/;
            if (val.match(re)) {
                dval = parseFloat(val).toFixed(2);
                makeCustomHTML += '<tr><td class=\'tdpadding\' ><b>' + capt + '</b></td><td class=\'tdpadding\' > ' + dval + '</td></tr>';
            }
            else {
                makeCustomHTML += '<tr><td class=\'tdpadding\' ><b>' + capt + '</b></td><td class=\'tdpadding\' > ' + roundIfNumeric(capitalize_Words(globalCollectionArray[i].row[j].value)) + '</td></tr>';
            }
        }
        makeCustomHTML += '</table></div>';
    }
    makeCustomHTML += '</div>';
    if (Number(globalCollectionArray.length) > 0) {
        document.getElementById("infodiv").innerHTML = makeCustomHTML;
        overlay.setPosition(_coordinate);
        jQuery('#div').css({
            position: 'absolute',
            display: 'block'
        });

    } else {
        document.getElementById("infodiv").innerHTML = 'No record found ....';
        overlay.setPosition(_coordinate);
        jQuery('#div').css({
            position: 'absolute',
            display: 'block'
        });
    }
}
function closeclick() {
    jQuery('#div').css('display', 'none');
}



/////////////////////////div dragable

dragElement(document.getElementById("div"));

function dragElement(elmnt) {
    let pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;

    // You can also use a specific header to drag if needed:
    // For example, document.getElementById("mydivheader")
    elmnt.onmousedown = dragMouseDown;

    function dragMouseDown(e) {
        e = e || window.event;
        e.preventDefault();

        // Get the mouse cursor position at startup:
        pos3 = e.clientX;
        pos4 = e.clientY;
        document.onmouseup = closeDragElement;
        document.onmousemove = elementDrag;
    }

    function elementDrag(e) {
        e = e || window.event;
        e.preventDefault();

        // Calculate the new cursor position:
        pos1 = pos3 - e.clientX;
        pos2 = pos4 - e.clientY;
        pos3 = e.clientX;
        pos4 = e.clientY;

        // Set the element's new position:
        elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
        elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
    }

    function closeDragElement() {
        // Stop moving when mouse button is released:
        document.onmouseup = null;
        document.onmousemove = null;
    }
}
