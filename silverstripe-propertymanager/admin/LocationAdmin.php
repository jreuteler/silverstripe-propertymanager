<?php

class LocationAdmin extends ModelAdmin
{

    private static $menu_title = 'Locations';

    private static $url_segment = 'locations';

    private static $managed_models = array(
        'Location'
    );

    private static $menu_icon = 'advanced-events/assets/icons/locations.png';
}