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


    jQuery('area').click(function (event) {
        event.preventDefault();
    });

    var zIndex = 2048;

    // var floorImageMaps = $FloorImageMapsJSON;

    var buildings = $BuildingsJSON;
    var buildingFloors = $BuildingFloorsJSON;


    function resetBuildingLayers(buildingID) {

        jQuery('#building-'+buildingID+' area.floor.active').removeClass('active');
        jQuery('#building-'+buildingID+' .property-klick-overlay.active').removeClass('active');

    }

    function resetFloorLayer(floorID) {

        jQuery('#floor-' + floorID).addClass('offset');

    }


    function getAffectedFloors(buildingID, triggeredFloorID) {

        var affectedFloors = [];
        var triggeredFloorFound = false;

        fLen = buildingFloors[buildingID].length;

        for (i = 0; i < fLen; i++) {

            let floorID = buildingFloors[buildingID][i];

            if (floorID != 0) {
                if (triggeredFloorFound) {

                    var floorLayer = jQuery('#floor-' + floorID);
                    affectedFloors.push(floorID);
                }
            }

            if (floorID == triggeredFloorID) {

                //console.log("floorID: " + floorID);

                triggeredFloorFound = true;
            }
        }

        function updateImageMap(buildingID, triggeredFloorID) {

        }


        console.log(affectedFloors);
        return affectedFloors;
    }


    $('map area.floor').entwine({

        /**
         onmatch: function(){
            this.css({height: 45, width: 200, clear: 'left'});
        },
         **/

        showfloor: function () {

            //this.animate({zIndex: 128}, {queue: false})
            // TODO: reset z-index on imagemap

            /**
            if(this.hasClass('active')) {

                resetBuildingLayers(this.data('building-id'));
                return;


            } else {
                this.addClass('active');
            }
            ***/

            var alreadOpen = false

            if(this.hasClass('active')) {

                // layer already open
                alreadOpen = true;
            }

            // reset all active floors
            jQuery('#building-'+this.data('building-id')+' area.floor.active').removeClass('active');


            //this.addClass('active');


            // reset property-klick-overlay
            jQuery('#building-'+this.data('building-id')+' .property-klick-overlay.active').removeClass('active');
            jQuery('#floor-'+this.data('floor-id')+' .property-click-overlay').addClass('active');

            // reset image maps of open floors
            jQuery('#building-' + this.data("building-id") + ' area.floor.offset').each(function () {

                jQuery(this).attr('coords', jQuery(this).data('initial-coords'));
            });


            this.coords = this.data("offset-coords");

            var floorsToAnimate = getAffectedFloors(this.data("building-id"), this.data("floor-id"));

            floorsToAnimate.forEach(function (item, index, array) {
                jQuery('#floor-' + item).addClass('offset');
                let clickarea = jQuery('#floor-clickarea-' + item);

                clickarea.addClass('offset');
                clickarea.attr('coords', clickarea.data('offset-coords'));
            });

            jQuery('#building-' + this.data("building-id")).addClass('offset');


            console.log(this.data("building-id"));
            console.log(this.data("floor-id"));

            //this.animate({height: 100}, {queue: false})
        },
        hidefloor: function () {

            this.animate({zIndex: this.data("z-index")}, {queue: false})
            jQuery('#building-' + this.data("building-id") + ' .floor-overlay').removeClass('offset');
            jQuery('#building-' + this.data("building-id")).removeClass('offset');

            //this.animate({height: 45}, {queue: false})
        },


        desaturate: function () {

            jQuery('#floor-' + this.data("floor-id")).addClass('desaturate');
            //this.animate({height: 100}, {queue: false})
        },
        saturate: function () {

            jQuery('#floor-' + this.data("floor-id")).removeClass('desaturate');
            //this.animate({height: 45}, {queue: false})
        },


        onclick: function () {
            this.showfloor();
        },
        ondblclick: function () {
            this.hidefloor();
        },
        onmouseenter: function () {
            this.desaturate();
        },
        onmouseleave: function () {
            this.saturate();
        }
    })


</script>

<div id="location-overview"
     style="background-image: url('$LocationBackground.URL'); width:{$LocationBackground.Width}px; height: {$LocationBackground.Height}px;">

    <% loop $BuildingsData %>

        <div id="building-{$ID}" class="building-overlay overlay"
             style="left: {$BuildingOffsetX}px; top: {$BuildingOffsetY}px;">
            <!--
            Building: $Title, $ID
            -->

            <!-- id="floor-click-overlay" -->
            <div class="floor-click-overlay overlay" style="z-index: 2048;">
                <img class="map" width="$Top.LocationBackgroundWidth"
                     height="{$Top.LocationBackground.Height}" src="$Top.PROPERTYMANAGER_DIR/assets/images/spacer.gif"
                     usemap="#imagemap-{$ID}">
            </div>

            <div id="roof-{$ID}" class="overlay roof-overlay"
                 style="background-image: url('$RoofImage.URL'); width: {$RoofImage.Width}px; height: {$RoofImage.Height}px; left: {$RoofOffsetX}px ; top: {$RoofOffsetY}px; z-index: 1024;"></div>

            <map id="imagemap-{$ID}" name="imagemap-{$ID}" style="z-index: 1;">
                <% loop $Floors.Reverse %>

                    <area id="floor-clickarea-{$ID}" class="floor" shape="poly"
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

                <div id="floor-{$ID}" class="overlay floor-overlay"
                     style="background-image: url('$OverviewImage.URL'); width: {$OverviewImage.Width}px; height: {$OverviewImage.Height}px; z-index: {$ZIndex};">

                    <!--
                    Floor: $Title
                    -->

                    <% loop $Properties %>
                        <div id="property_{$ID}" class="overlay property-overlay"
                             style="background-image: url('$OverviewImage.URL'); width: {$OverviewImage.Width}px; height: {$OverviewImage.Height}px;">

                        </div>
                    <% end_loop %>


                    <div class="property-click-overlay overlay" style="z-index: 2048;">
                        <img class="map" width="$Top.LocationBackgroundWidth"
                             height="{$Top.LocationBackground.Height}"
                             src="$Top.PROPERTYMANAGER_DIR/assets/images/spacer.gif"
                             usemap="#property-imagemap-{$ID}">
                    </div>


                </div>

            <% end_loop %>
        </div>

    <% end_loop %>

</div>


<!-- create property image maps per floor -->
<% loop $BuildingsData %>
    <% loop $Floors %>
        <map id="property-imagemap-{$ID}" name="property-imagemap-{$ID}" style="z-index: 1;">
            <% loop $Properties %>
                <area id="property-clickarea-{$ID}" class="property" shape="poly"
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
    <% end_loop %>
<% end_loop %>
