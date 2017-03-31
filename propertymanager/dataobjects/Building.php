<?php

class Building extends DataObject
{

    public static $db = array(
        'Title' => 'Varchar',
        'Text' => 'Text',
        'BuildingOffsetX' => 'Int',
        'BuildingOffsetY' => 'Int',
        'RoofOffsetX' => 'Int',
        'RoofOffsetY' => 'Int',
    );

    public static $has_one = array(
        'Location' => 'Location',
        'RoofImage' => 'Image',
    );

    public static $has_many = array(
        'Floors' => 'Floor',
    );

    public static $belongs_to = array(
        'Location' => 'Location',
    );

    private static $summary_fields = array(
        'Title',
        'LocationTitle'
    );

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        return $fields;
    }

    public function LocationTitle()
    {
        if ($this->Location())
            return $this->Location()->Title;

        return '';
    }


}
