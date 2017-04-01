<?php

class Property extends DataObject
{

    public static $db = array(
        'Title' => 'Varchar',
        'Type' => 'Enum("Residential,Commercial","Commercial")',
        'Description' => 'Text',
    );

    public static $has_one = array(
        'Floor' => 'Floor',
        'OverviewImage' => 'Image',
    );


    private static $summary_fields = array(
        'Type', 'Title'
    );

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        return $fields;
    }


    public function BuildingID()
    {
        if($this->Floor() && $this->Floor()->Building() ) {
            return $this->Floor()->Building()->ID;
        }

        return 0;
    }


}
