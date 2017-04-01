<% include EventTooltipConfiguration %>


<style>

    img[usemap] { border: 1px solid red; }

        $DynamicCSS

</style>


<script type='text/javascript'>

    jQuery('.map').maphilight();



    var floorImageMaps = $FloorImageMapsJSON;

    var buildings = $BuildingsJSON;
    var buildingFloors = $BuildingFloorsJSON;

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

    $('map area.floor').data('ma-test', 'active');
    $('map area.floor').css('border', '1px solod red');


    $('map area.floor').entwine({
        onclick: function (e) {
            var id = this.val(),

                    form = this.closest('form');

            var buildingID = this.data("building-id");
            var floorID = this.data("floor-id");

            console.log("id: " + this.id);
            console.log("buildingID: " + buildingID + " / floorID: " + floorID);
            //console.log(buildingFloors[1].length);


            var id = this.attr('id');

            console.log(id);

            /**
             for(var i = 0; i < buildingFloors[buildingID].length; i++) {
                //console.log(buildingFloors[1]);
                console.log('loop floor #'.buildingFloors[buildingID][i]);
            }

             **/


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


                // TODO:
                /**
                 * get all "moved" floors and replace imagemap
                 */

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


                this.addClass('active');

            }


            this._super();
        }
    });

</script>

<div id="location_overview"
     style="background-image: url('$LocationBackground.URL'); width:{$LocationBackground.Width}px; height: {$LocationBackground.Height}px;">

    <% loop $BuildingsData %>

        <div id="building_{$ID}" class="building_overlay overlay" style="left: {$BuildingOffsetX}px; top: {$BuildingOffsetY}px;">
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
                <% loop $Floors %>

                    <!--
                    onmouseover="showFloor('$ID')" onmouseout="hideFloor('$ID')" onclick="showFloorDetails('$ID')"
                          -->

                    <area id="floor_clickarea_{$ID}" class="floor" shape="poly"
                          coords="$OverviewImage.ImageMapCoordinates"
                          data-building-id="$BuildingID"
                          data-floor-id="$ID"
                          about="data-tooltip-content="#tooltip_content_floor_{$ID}"
                          href="#" alt="$Title"
                          title="$Title"/>

                <% end_loop %>
            </map>

            <% loop $Floors %>

                <div id="floor_{$ID}" class="overlay floor_overlay"
                     style="background-image: url('$OverviewImage.URL'); width: {$OverviewImage.Width}px; height: {$OverviewImage.Height}px; z-index: $ZIndex;">

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
