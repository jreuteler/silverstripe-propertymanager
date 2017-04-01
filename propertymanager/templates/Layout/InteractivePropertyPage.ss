<% include PropertyList %>


<% include EventTooltipConfiguration %>


<style>

    img[usemap] {
        border: 1px solid red;
    }

        $DynamicCSS

</style>


<script type='text/javascript'>

    //jQuery('.map').maphilight();


    jQuery('area').click(function( event ) {
        event.preventDefault();
    });


    /**

    var test = jQuery('area.floor');

    console.log(test.length);

    for (var prop in test ) {

        console.log(prop);

    }
     **/

         var zIndex = 2048;

    // var floorImageMaps = $FloorImageMapsJSON;

    var buildings = $BuildingsJSON;
    var buildingFloors = $BuildingFloorsJSON;

    function resetFloorLayer(floorID) {


        jQuery('#floor' + floorID).addClass('offset');

    }


    function getAffectedFloors(buildingID, triggeredFloorID) {

        var affectedFloors = [];
        var triggeredFloorFound = false;

        //console.log("getAffectedFloors (" + buildingID +  ", " + triggeredFloorID + ")");

        fLen = buildingFloors[buildingID].length;

        for (i = 0; i < fLen; i++) {

            let floorID = buildingFloors[buildingID][i];

            if (floorID != 0) {
                if (triggeredFloorFound) {

                    var floorLayer = jQuery('#floor_' + floorID);
                    affectedFloors.push(floorID);
                }
            }

            if (floorID == triggeredFloorID) {

                //console.log("floorID: " + floorID);

                triggeredFloorFound = true;
            }
        }


        /**

         for (var floorID in buildingFloors[buildingID]) {

            console.log("floorID: " + floorID);
            // TODO: find reasons for 0 values (null?)
            if(floorID != 0) {
                if(triggeredFloorFound){

                    var floorLayer = jQuery('#floor_'+floorID);
                    affectedFloors.push(floorLayer);
                }
            }

            if(floorID == triggeredFloorID) {
                triggeredFloorFound = true;
            }

        }
         **/

        function updateImageMap(buildingID, triggeredFloorID) {

        }


        /**
         for(i = 0; i < buildingFloors[buildingID].length; i++ ) {

            if(triggeredFloorFound){
                affectedFloors.push(jQuery('floor_'+buildingFloors[buildingID]));
            }

            if(buildingFloors[buildingID] == triggeredFloorID) {
                triggeredFloorFound = true;
            }


        }
         **/

        console.log(affectedFloors);
        return affectedFloors;
    }

    // var buildingFloorsJSON = JSON.parse(buildingFloors);


    /*
    $('map area.floor').entwine({
        expand: function() {
            this.animate({height: 100}, {queue: false})
        },
        collapse: function() {
            this.animate({height: 45}, {queue: false})
        },
        onmouseenter: function(){
            this.expand();
        },
        onmouseleave: function(){
            this.collapse();
        }
    })
    */


    $('map area.floor').entwine({

        /**
         onmatch: function(){
            this.css({height: 45, width: 200, clear: 'left'});
        },
         **/

        showfloor: function () {


            //this.animate({zIndex: 128}, {queue: false})



            // TODO: reset z-index on imagemap

            // reset image maps of open floors
            console.log('reset image maps');

            jQuery('#building_'+this.data("building-id") +' area.floor.offset').each(function() {

                jQuery( this ).attr('coords', jQuery( this ).data('initial-coords'));
            });



            console.log('floor clicked, #' + this.data("floor-id"));

            this.coords = this.data("offset-coords");

            var floorsToAnimate = getAffectedFloors(this.data("building-id"), this.data("floor-id"));

            floorsToAnimate.forEach(function (item, index, array) {
                jQuery('#floor_'+item).addClass('offset');
                let clickarea = jQuery('#floor_clickarea_'+item);

                clickarea.addClass('offset');
                clickarea.attr('coords', clickarea.data('offset-coords'));
            });

            jQuery('#building_' + this.data("building-id")).addClass('offset');

            /*
            for (var floor in floorsToAnimate) {
                //floor.addClass('moved');
                console.log('floor value: ' + floor);
                console.log('floor value: ' + floorsToAnimate[floor]);

            }
            **/

            console.log(this.data("building-id"));
            console.log(this.data("floor-id"));
            //jQuery('#'+this.data("floor-layer-id")).addClass('moved');

            //this.addClass('moved');
            //this.animate({height: 100}, {queue: false})
        },
        hidefloor: function () {
            //this.removeClass('moved');

            this.animate({zIndex: this.data("z-index")}, {queue: false})
            jQuery('#building_' + this.data("building-id") + ' .floor_overlay').removeClass('offset');
            jQuery('#building_' + this.data("building-id")).removeClass('offset');

            //this.animate({height: 45}, {queue: false})
        },


        desaturate: function() {

            jQuery('#floor_' + this.data("floor-id")).addClass('desaturate');

            //this.animate({height: 100}, {queue: false})
        },
        saturate: function() {

            jQuery('#floor_' + this.data("floor-id")).removeClass('desaturate');

            //this.animate({height: 45}, {queue: false})
        },


        onclick: function () {
            this.showfloor();
        },
        ondblclick: function () {
            this.hidefloor();
        },

        onmouseenter: function(){
            this.desaturate();
        },
        onmouseleave: function(){
            this.saturate();
        }
    })

    /**
     $('ul.horizontal li').entwine({
        onmatch: function(){
            this.css({height: 100, width: 45, clear: 'none'});
        },
        showfloor: function(){
            this.animate({width: 200}, {queue: false})
        },
        hidefloor: function(){
            this.animate({width: 45}, {queue: false})
        }
    })

     $('ul.lightens li').entwine({
        Highlight: '#ced',

        onmouseenter: function(){
            this.animate({backgroundColor: this.getHighlight()}, {queue: false});
            this._super();
        },
        onmouseleave: function(){
            this.animate({backgroundColor: '#ccc'}, {queue: false});
            this._super();
        }
    })
     **/


    //   this.imageMap.empty();
    /***
     var area = new Element('area', {
                    'shape': 'poly',
                    'coords': pointList,
                    'onmouseover': '',
                    'onclick': 'showFloor(\''+floorId+'\')',
                    'class': 'floorTooltip',
                    'title': floorName,
                    'rel': 'Anklicken für Details',
                    'href': '#',
                    'alt': 'alt text'
                });

     */


    /**
     $('map area.floor').entwine({
        onclick: function (e) {
            var id = this.val(),

                    form = this.closest('form');

            var buildingID = this.data("building-id");
            var floorID = this.data("floor-id");

            console.log("id: " + this.id);
            console.log("buildingID: " + buildingID + " / floorID: " + floorID);


            var id = this.attr('id');

            console.log(id);

              var roofElement = jQuery('#roof_' + buildingID);

            if (this.hasClass('active')) {

                // reset all floor overlays of the relevant building
                jQuery('.floor_overlay').removeClass('moved');
                roofElement.removeClass('moved');


                this.removeClass('active');

            } else {

                var json = buildingFloors[buildingID];

                roofElement.addClass('moved');

                var move = false;
                for (var key in json) {
                    if (json.hasOwnProperty(key)) {


                        var floorElementID = '#floor_'+ json[key];
                        var floorElement = jQuery(floorElementID);


                        if(move) {
                            floorElement.addClass('moved');
                            console.log(floorElementID + ' MOVED');

                        } else {
                            floorElement.removeClass('moved');
                            console.log(floorElementID + ' DEFAULT POS');
                        }



                        if(floorID == json[key]) {
                            console.log(floorID + ' == ' + json[key]);
                            move = true;
                        }

                    }
                }
                this.addClass('active');

            }


            this._super();
        }
    });


     **/

</script>

<div id="location_overview"
     style="background-image: url('$LocationBackground.URL'); width:{$LocationBackground.Width}px; height: {$LocationBackground.Height}px;">

    <% loop $BuildingsData %>

        <div id="building_{$ID}" class="building_overlay overlay"
             style="left: {$BuildingOffsetX}px; top: {$BuildingOffsetY}px;">
            <!--
            Building: $Title, $ID
            -->

            <div id="klick_overlay" class="overlay" style="z-index: 2048;">
                <img class="map" width="$Top.LocationBackgroundWidth"
                     height="{$Top.LocationBackground.Height}" src="$Top.PROPERTYMANAGER_DIR/assets/images/spacer.gif"
                     usemap="#imageMap_{$ID}">
            </div>

            <div id="roof_{$ID}" class="overlay roof_overlay"
                 style="background-image: url('$RoofImage.URL'); width: {$RoofImage.Width}px; height: {$RoofImage.Height}px; left: {$RoofOffsetX}px ; top: {$RoofOffsetY}px; z-index: 1024;"></div>

            <map id="imageMap_{$ID}" name="imageMap_{$ID}" style="z-index: 1;">
                <% loop $Floors.Reverse %>

                    <!--
                    onmouseover="showFloor('$ID')" onmouseout="hideFloor('$ID')" onclick="showFloorDetails('$ID')"
                          -->

                    <area id="floor_clickarea_{$ID}" class="floor" shape="poly"
                          coords="$OverviewImage.ImageMapCoordinates"
                          data-building-id="$BuildingID"
                          data-floor-id="$ID"
                          data-floor-layer-id="floor_{$ID}"
                          data-z-index="{$SortOrder}"
                          data-initial-coords="$OverviewImageMapCoordinates"
                          data-offset-coords="$OverviewImageMapCoordinatesOffset"
                          about="data-tooltip-content=" #tooltip_content_floor_{$ID}"
                    href="#" alt="$Title"
                    title="$Title" />

                <% end_loop %>
            </map>

            <% loop $Floors %>

                <div id="floor_{$ID}" class="overlay floor_overlay"
                     style="background-image: url('$OverviewImage.URL'); width: {$OverviewImage.Width}px; height: {$OverviewImage.Height}px; z-index: {$ZIndex};">

                    <!--
                    Floor: $Title
                    -->

                    <% loop $Properties %>

                        <div id="property_{$ID}" class="overlay property_overlay"
                             style="background-image: url('$OverviewImage.URL'); width: {$OverviewImage.Width}px; height: {$OverviewImage.Height}px;">

                        </div>

                    <% end_loop %>


                </div>

            <% end_loop %>
        </div>

    <% end_loop %>

</div>
