<?php

class InputFieldTestAdmin extends ModelAdmin
{

    private static $menu_title = 'InputFieldTest';

    private static $url_segment = 'inputfieldtests';

    private static $managed_models = array(
        'InputFieldTest'
    );

    private static $menu_icon = 'advanced-events/assets/icons/InputFieldTest.png';
}