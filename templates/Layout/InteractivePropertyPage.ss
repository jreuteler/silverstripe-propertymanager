<% include EventTooltipConfiguration %>


<style>
        $DynamicCSS
</style>


<script type='text/javascript'>

    // disable click on imagemap areas
    $(function () {
        jQuery('#imagemap area').on('click', function (e) {
            e.preventDefault();
        });
    });

    // contains a list of floors grouped by building
    var buildingFloors = $BuildingFloorsJSON;

    $('.floor.click-area').entwine({

        showfloor: function () {

            var buildingID = this.data('building-id');
            var floorID = this.data('floor-id');
            var isActive = this.hasClass('active');

            // replace all offset imagemap coordinates with the initial (non-offset) ones
            jQuery('.building-' + buildingID + ' area.floor.offset').each(function () {
                jQuery(this).attr('coords', jQuery(this).data('initial-coords'));
            });

            // delete coords of active properties (required because a map area can't be individually de-/activated with CSS block:none;)
            jQuery('area.property.active').each(function () {
                jQuery(this).removeClass('active');
                jQuery(this).attr('coords', '');
            });

            // reset all active/offset elements
            jQuery('.roof-' + buildingID + ' .offset').removeClass('offset'); // reset roof offset
            jQuery('.building-' + buildingID + ' .offset').removeClass('offset'); // reset offset of all floors
            jQuery('.building-' + buildingID + ' .active').removeClass('active'); // reset any floor marked as active


            if (!isActive) {

                this.addClass('active');

                // set roof as offset
                jQuery('.roof-' + buildingID).addClass('offset');

                // set selected floor as active
                jQuery('.floor-' + floorID).addClass('active');

                // activate floor click layer
                jQuery('.floor-' + floorID + ' .property-click-overlay').addClass('active');

                // set coords of properties (required because a map area can't be individually de-/activated with CSS block:none;)
                jQuery('area.property.floor-' + floorID).each(function () {
                    jQuery(this).addClass('active');
                    jQuery(this).attr('coords', jQuery(this).data('initial-coords'));
                });

                //this.coords = this.data("offset-coords");
                var floorsToOffset = getAffectedFloors(buildingID, floorID);
                floorsToOffset.forEach(function (item, index, array) {

                    // set offset class on floor layer
                    jQuery('.floor-' + item).addClass('offset');

                    let clickarea = jQuery('.floor-clickarea-' + item);

                    // set offset class on clickarea
                    clickarea.addClass('offset');

                    // replace coordinates with offset ones
                    clickarea.attr('coords', clickarea.data('offset-coords'));
                });

            }

        },

        desaturate: function () {
            jQuery('.floor-' + this.data('floor-id')).removeClass('saturate');
        },
        saturate: function () {
            jQuery('.floor-' + this.data('floor-id')).addClass('saturate');
        },


        onclick: function () {
            this.showfloor();
        },

        onmouseenter: function () {
            this.saturate();
        },
        onmouseleave: function () {
            this.desaturate();
        }
    })


    $('map area.property').entwine({

        desaturate: function () {
            jQuery('.property-' + this.data('property-id')).removeClass('saturate');
        },
        saturate: function () {
            jQuery('.property-' + this.data('property-id')).addClass('saturate');
        },

        onmouseenter: function () {
            this.saturate();
        },
        onmouseleave: function () {
            this.desaturate();
        }
    })


    function getAffectedFloors(buildingID, triggeredFloorID) {

        var affectedFloors = [];
        var triggeredFloorFound = false;
        fLen = buildingFloors[buildingID].length;

        for (i = 0; i < fLen; i++) {

            let floorID = buildingFloors[buildingID][i];
            if (floorID != 0) {
                if (triggeredFloorFound) {
                    affectedFloors.push(floorID);
                }
            }
            if (floorID == triggeredFloorID) {
                triggeredFloorFound = true;
            }
        }

        return affectedFloors;
    }



</script>


<div id="location-navigation">
    <ul>
        <% loop $BuildingsData %>
            <li class="building-$ID">$Title</li>

            <ul class="building-$ID">

                <% loop $Floors %>
                    <li class="floor floor-{$ID} click-area" data-building-id="$BuildingID"
                        data-floor-id="$ID">$Title            </li>

                <% end_loop %>
            </ul>
        <% end_loop %>
    </ul>

</div>

<div id="location-overview"
     style="background-image: url('$LocationBackground.URL'); width:{$LocationBackground.Width}px; height: {$LocationBackground.Height}px;">

    <div class="floor-click-overlay overlay" style="z-index: 2048;">
        <img class="map" width="$LocationBackgroundWidth"
             height="{$LocationBackground.Height}" src="$Top.PROPERTYMANAGER_DIR/assets/images/spacer.gif"
             usemap="#imagemap">
    </div>


    <% loop $BuildingsData %>

        <div id="building-{$ID}" class="overlay building-overlay building-{$ID}"
             style="left: {$BuildingOffsetX}px; top: {$BuildingOffsetY}px;">

            <div id="roof-{$ID}" class="overlay roof-overlay roof-{$ID}"
                 style="background-image: url('$RoofImage.URL'); width: {$RoofImage.Width}px; height: {$RoofImage.Height}px; left: {$RoofOffsetX}px ; top: {$RoofOffsetY}px; z-index: 1024;"></div>

            <map id="imagemap" name="imagemap" style="z-index: 1;">
                <% loop $Floors.Reverse %>

                    <% loop $Properties %>
                        <area id="property-clickarea-{$ID}" class="property floor-{$FloorID}" shape="poly"
                              coords=""
                              data-initial-coords="$OverviewImageMapCoordinates"
                              data-property-id="$ID"
                              href="#" alt="$Title"
                              title="$Title"/>
                    <% end_loop %>

                    <area id="floor-clickarea-{$ID}" class="floor click-area floor-clickarea-{$ID}" shape="poly"
                          coords="$OverviewImageMapCoordinates"
                          data-building-id="$BuildingID"
                          data-floor-id="$ID"
                          data-floor-layer-id="floor-{$ID}"
                          data-initial-coords="$OverviewImageMapCoordinates"
                          data-offset-coords="$OverviewImageMapCoordinatesOffset"
                          about="data-tooltip-content=" #tooltip_content_floor_{$ID}"
                    href="#" alt="$Title"
                    title="$Title" />

                <% end_loop %>
            </map>

            <% loop $Floors %>

                <div id="floor-{$ID}" class="overlay floor-overlay floor-{$ID}"
                     style="background-image: url('$OverviewImage.URL'); width: {$OverviewImage.Width}px; height: {$OverviewImage.Height}px; z-index: {$ZIndex};"
                     data-z-index="{$ZIndex}">

                    <% loop $Properties %>
                        <div id="property-{$ID}" class="overlay property-overlay property-{$ID}"
                             style="background-image: url('$OverviewImage.URL'); width: {$OverviewImage.Width}px; height: {$OverviewImage.Height}px;">

                        </div>
                    <% end_loop %>

                </div>

            <% end_loop %>
        </div>

    <% end_loop %>

</div>


