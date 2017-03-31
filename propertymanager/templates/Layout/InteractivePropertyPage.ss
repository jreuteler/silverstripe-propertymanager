<script type='text/javascript'>
    $('map area').entwine({
        expand: function() {
            this.animate({top: 100}, {queue: false})
        },
        collapse: function() {
            this.animate({top: 0}, {queue: false})
        },
        onmouseenter: function(){
            this.expand();
        },
        onmouseleave: function(){
            this.collapse();
        }
    })
</script>

<div id="location_overview"
     style="background-image: url('$LocationBackground.URL'); width:{$LocationBackground.Width}px; height: {$LocationBackground.Height}px;">

    <% loop $Buildings %>

        <div class="building_overlay overlay" style="left: {$BuildingOffsetX}px; top: {$BuildingOffsetY}px;">
            <!--
            Building: $Title
            -->

            <div id="klick_overlay" class="overlay" style="z-index: 2048;">>
                <img width="$Top.LocationBackgroundHeight" width="{$Top.Locations.Width}"
                     height="{$Top.Locations.Height}" src="$Top.PROPERTYMANAGER_DIR/assets/images/spacer.gif"
                     usemap="#imageMap">
            </div>

            <div id="roof_$ID" class="overlay roof_overlay"
                 style="background-image: url('$RoofImage.URL'); width: {$RoofImage.Width}px; height: {$RoofImage.Height}px; left: {$RoofOffsetX}px ; top: {$RoofOffsetY}px; z-index: 1024;"></div>

            <map id="imageMap" name="imageMap" style="z-index: 1;">
                <% loop $Floors %>

                    <!--
                    onmouseover="showFloor('$ID')" onmouseout="hideFloor('$ID')" onclick="showFloorDetails('$ID')"
                     -->

                    <area shape="poly" coords="$OverviewImage.ImageMapCoordinates"

                          href="#" alt="$Title"
                          title="$Title"/>
                <% end_loop %>
            </map>

            <% loop $Floors %>

                <div id="floor_$ID" class="overlay floor_overlay"
                     style="background-image: url('$OverviewImage.URL'); width: {$OverviewImage.Width}px; height: {$OverviewImage.Height}px; z-index: $ZIndex;">

                    <!--
                    Floor: $Title
                    -->

                    <% loop $Properties %>

                        <div id="property_$ID" class="overlay floor_overlay"
                             style="background-image: url('$OverviewImage.URL'); width: {$OverviewImage.Width}px; height: {$OverviewImage.Height}px;">

                        </div>

                    <% end_loop %>


                </div>

            <% end_loop %>
        </div>

    <% end_loop %>

</div>
