<?php

class Floor extends DataObject
{

    public static $db = array(
        'Title' => 'Varchar',
        'Text' => 'Text',
        'SortOrder'=>'Int'
    );

    public static $has_one = array(
        'Building' => 'Building',
        'OverviewImage' => 'Image',
    );

    public static $has_many = array(
        'Properties' => 'Property',
    );

    public static $default_sort='SortOrder';


    private static $summary_fields = array(
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

    public function OverviewImageMapCoordinates()
    {
        if($this->OverviewImage()) {
            return $this->OverviewImage()->ImageMapCoordinates;
        }

        return '';
    }

    public function OverviewImageMapCoordinatesOffset()
    {
        return  ImageMapHelper::calculateOffset($this->OverviewImageMapCoordinates(), $this->Building()->AnimationOffsetX, $this->Building()->AnimationOffsetY);
        // $this->OverviewImage->ImageMapCoordinates;
    }


    public function ZIndex() {
        return $this->SortOrder+128;
    }

}


