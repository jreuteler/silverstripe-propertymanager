<?php

class Location extends DataObject
{

    public static $db = array(
        'Title' => 'Varchar',
        'Text' => 'Text',
    );

    public static $has_one = array(
        'BackgroundImage' => 'Image',
    );

    public static $has_many = array(
        'Buildings' => 'Building',
    );



    private static $summary_fields = array(
        'Title'
    );

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        return $fields;
    }

}
