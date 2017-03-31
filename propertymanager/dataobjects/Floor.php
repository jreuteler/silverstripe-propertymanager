<?php

class Floor extends DataObject
{

    public static $db = array(
        'Title' => 'Varchar',
        'FloorId' => 'Int',
        'Text' => 'Text',
    );

    public static $has_one = array(
        'Building' => 'Building',
        'OverviewImage' => 'Image',
    );

    public static $has_many = array(
        'Properties' => 'Property',
    );

    private static $summary_fields = array(
        'FloorId',
        'Title',
        'PropertyCount',
    );

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();

        return $fields;
    }


    public function PropertyCount()
    {
        if ($this->Properties())
            return $this->Properties()->Count();

        return 0;
    }


    public function ZIndex() {
        return $this->FloorId;
    }

}


